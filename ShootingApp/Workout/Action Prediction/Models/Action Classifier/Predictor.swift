//
//  Predictor.swift
//  ShootingApp
//
//  Created by soham gupta on 7/8/21.
//

import Foundation
import Vision

protocol PredictorDelegate: AnyObject{
    // the didFindNewRecognizedPoints function receives an array of points
    func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint])
    func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double)
    // this passes up angles to the main screen
}
class Predictor{
    //connectes the predictor class to the delegate bariable
    weak var delegate: PredictorDelegate?
    
    let predictionWindowSize = 64
    
    //MARK: this array can help us to do angle analysis after the workout is done
    var posesWindow: [VNHumanBodyPoseObservation] = []
    
    var request = VNDetectHumanBodyPoseRequest()

    init(){
        posesWindow.reserveCapacity(predictionWindowSize)
        request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)
    }
    // this takes in the data from the camera
    func estimation(sampleBuffer: CMSampleBuffer) {
        let requestHandler = VNImageRequestHandler(cmSampleBuffer: sampleBuffer, orientation: .up)

        do {
            // this runs a human body pose request and gives the data to the bodyPoseHandler
            try requestHandler.perform([request])
        } catch {
            print("NOT WORKING")
        }
    }
    
    // this manages observations from the body Pose Request
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations = request.results as? [VNHumanBodyPoseObservation] else {return}
        
        observations.forEach {
            processObservation($0)
        }
        
        if let result = observations.first {
            storeObservation(result)
            
            labelActionType()
        }
    }
    
    func labelActionType(){
        guard let throwingClassifier = try? FormShootingClassifier(configuration: MLModelConfiguration()),
            let poseMultiArray = prepareInputWithObservations(posesWindow),
            let predictions = try? throwingClassifier.prediction(poses: poseMultiArray) else {
            print("returning")
            return
        }
        
        let label = predictions.label
        let confidence = predictions.labelProbabilities[label] ?? 0
        print("\(label)\(confidence)")
        delegate?.predictor(self, didLabelAction: label, with: confidence)
    }
    
    func prepareInputWithObservations(_ observations: [VNHumanBodyPoseObservation]) -> MLMultiArray? {
        let numAvailableFrames = observations.count
        let observationsNeeded = 64
        var multiArrayBuffer = [MLMultiArray]()
        
        for frameIndex in 0 ..< min(numAvailableFrames, observationsNeeded){
            let pose = observations[frameIndex]
            do {
                let oneFrameMultiArray = try pose.keypointsMultiArray()
                multiArrayBuffer.append(oneFrameMultiArray)
            } catch {
                continue
            }
        }
        
        
        if numAvailableFrames < observationsNeeded {
            for _ in 0 ..< (observationsNeeded - numAvailableFrames) {
                do {
                    let oneFrameMultiArray = try MLMultiArray(shape: [1,3,18], dataType: .double)
                    try resetMultiArray(oneFrameMultiArray)
                    multiArrayBuffer.append(oneFrameMultiArray)
                } catch {
                    continue
                }
            }
        }
        return MLMultiArray(concatenating: [MLMultiArray](multiArrayBuffer), axis: 0, dataType: .float)
    }
    
    func resetMultiArray(_ predictionWindow: MLMultiArray, with value: Double = 0.0) throws {
        let pointer = try UnsafeMutableBufferPointer<Double>(predictionWindow)
        pointer.initialize(repeating: value)
    }
    
    func storeObservation(_ observation: VNHumanBodyPoseObservation){
        if posesWindow.count >= predictionWindowSize {
            posesWindow.removeFirst()
        }
        posesWindow.append(observation)
    }
    // this processes a single observation
    func processObservation(_ observation: VNHumanBodyPoseObservation){
        do {
            // these are the points that the observation is guessing
            let recognizedPoints = try observation.recognizedPoints(forGroupKey: .all)
            // this is mapping these points to a new coordinate system that can be shown on the screen
            // this needs to be passed to the view controller in order to display
            let displayedPoints = recognizedPoints.map {
                CGPoint(x: $0.value.x, y: 1 - $0.value.y)
            }
            // tell the delegate to display the points
            delegate?.predictor(self, didFindNewRecognizedPoints: displayedPoints)
        } catch {
            print("error finding recognized points")
        }
        
    }
}
