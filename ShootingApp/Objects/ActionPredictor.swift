////
////  ActionPredictor.swift
////  ShootingApp
////
////  Created by soham gupta on 7/13/21.
////
//
//import Foundation
//import CoreML
//import Vision
//
//class ActionPredictor{
//    let fitnessClassifier = ExerciseClassifier()
//
//    let request : VNDetectHumanBodyPoseRequest
//
//    var posesWindow: [VNRecognizedPointsObservation?] = []
//
//    var predictionWindowSize = 48
//
//    var observations : [VNHumanBodyPoseObservation] = []
//
//    init(){
//        posesWindow.reserveCapacity(64)
//        request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)
//    }
//
//    func processFrame(_ samplebuffer: CMSampleBuffer) throws -> [VNRecognizedPointsObservation] {
//        // vision body pose request
//        let framePoses = extractPoses(from: samplebuffer)
//        //selects the most prominent person
//        let pose = try selectMostProminentPerson(from: framePoses)
//        // adds the pose to window
//        posesWindow.append(pose)
//
//        return framePoses
//    }
//
//    var isReadyToMakePrediction: Bool {
//        posesWindow.count == predictionWindowSize
//    }
//
//    func makePrediction() throws -> PredictionOutput {
//        let poseMultiArrays: [MLMultiArray] = try posesWindow.map { person in
//            guard let person = person else {
//                return zeroPaddedMultiArray()
//            }
//            return try person.keypointsMultiArray()
//        }
//
//        let modelInput = MLMultiArray(concatenating: poseMultiArrays, axis: 0, dataType: .float)
//        let predictions = try fitnessClassifier.prediction(poses: modelInput)
//        posesWindow.removeFirst(predictionInterval)
//
//        return (
//            label: predictions.label,
//            confidence: predictions.labelProbabilities[predictions.label]!
//        )
//    }
//}
//
//extension ActionPredictor {
//    func extractPoses(from: CMSampleBuffer){
//        let requestHandler = VNImageRequestHandler(cmSampleBuffer: from)
//
//        do {
//            try requestHandler.perform([request])
//        } catch {
//            print("AHHHHHH")
//        }
//    }
//
//    func bodyPoseHandler(request: VNRequest, error: Error?){
//        guard observations = request.results as? [VNHumanBodyPoseObservation] else {
//            return
//        }
//    }
//
//}


