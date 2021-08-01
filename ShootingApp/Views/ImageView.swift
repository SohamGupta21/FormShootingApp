//
//  ImageView.swift
//  ShootingApp
//
//  Created by soham gupta on 7/30/21.
//
import UIKit
import SwiftUI

struct ImageView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(dM: dataModel)
    }
    
    @ObservedObject var dataModel : DataModel
    
    init(dM: DataModel){
        dataModel = dM
    }
    
    func makeUIView(context: Context) -> UIImageView {
        updateUILabelsWithPrediction(.startingPrediction)
        dataModel.videoCapture.updateDeviceOrientation()
        dataModel.videoCapture.delegate = context.coordinator
        dataModel.videoProcessingChain.delegate = context.coordinator
        dataModel.imageView.frame = UIScreen.main.bounds
        return dataModel.imageView;
    }
    
    func updateUIView(_ uiView: UIImageView, context: Context) {
    }

    func updateUILabelsWithPrediction(_ prediction : ActionPrediction){
        DispatchQueue.main.async {
            dataModel.predictionText = prediction.label
        }

        // Update the UI's confidence label on the main thread.
        let confidenceString = prediction.confidenceString ?? "Observing..."
        DispatchQueue.main.async { dataModel.confidenceText = confidenceString }
    }
    
    class Coordinator: NSObject, VideoCaptureDelegate, VideoProcessingChainDelegate {
        @ObservedObject var dataModel : DataModel
        init(dM: DataModel){
            dataModel = dM
            super.init()
            dataModel.videoCapture.delegate = self
            dataModel.videoProcessingChain.delegate = self
        }
        
        func videoCapture(_ videoCapture: VideoCapture, didCreate framePublisher: FramePublisher) {
            updateUILabelsWithPrediction(.startingPrediction)
            
            self.dataModel.videoProcessingChain.upstreamFramePublisher = framePublisher
        }
        
        func videoProcessingChain(_ chain: VideoProcessingChain, didDetect poses: [Pose]?, in frame: CGImage) {
            DispatchQueue.global(qos: .userInteractive).async {
                // Draw the poses onto the frame.
                self.drawPoses(poses, onto: frame)
            }
        }
        func videoProcessingChain(_ chain: VideoProcessingChain, didPredict actionPrediction: ActionPrediction, for frames: Int) {
            if actionPrediction.isModelLabel {
                // Update the total number of frames for this action.
                addFrameCount(frames, to: actionPrediction.label)
            }

            // Present the prediction in the UI.
            updateUILabelsWithPrediction(actionPrediction)
        }
        func updateUILabelsWithPrediction(_ prediction : ActionPrediction){
            DispatchQueue.main.async { self.dataModel.predictionText = prediction.label }

            // Update the UI's confidence label on the main thread.
            let confidenceString = prediction.confidenceString ?? "Observing..."
            DispatchQueue.main.async { self.dataModel.confidenceText = confidenceString }
        }
        func addFrameCount(_ frameCount: Int, to actionLabel: String) {
            // Add the new duration to the current total, if it exists.
            let totalFrames = (self.dataModel.actionFrameCounts[actionLabel] ?? 0) + frameCount

            // Assign the new total frame count for this action.
            self.dataModel.actionFrameCounts[actionLabel] = totalFrames
        }
        func drawPoses(_ poses: [Pose]?, onto frame: CGImage) {
            // Create a default render format at a scale of 1:1.
            let renderFormat = UIGraphicsImageRendererFormat()
            renderFormat.scale = 1.0

            // Create a renderer with the same size as the frame.
            //let frameSize = CGSize(width: frame.width, height: frame.height)
            let frameSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 200)
            let poseRenderer = UIGraphicsImageRenderer(size: frameSize,
                                                       format: renderFormat)

            // Draw the frame first and then draw pose wireframes on top of it.
            let frameWithPosesRendering = poseRenderer.image { rendererContext in
                // The`UIGraphicsImageRenderer` instance flips the Y-Axis presuming
                // we're drawing with UIKit's coordinate system and orientation.
                let cgContext = rendererContext.cgContext

                // Get the inverse of the current transform matrix (CTM).
                let inverse = cgContext.ctm.inverted()

                // Restore the Y-Axis by multiplying the CTM by its inverse to reset
                // the context's transform matrix to the identity.
                cgContext.concatenate(inverse)

                // Draw the camera image first as the background.
                let imageRectangle = CGRect(origin: .zero, size: frameSize)
                cgContext.draw(frame, in: imageRectangle)

                // Create a transform that converts the poses' normalized point
                // coordinates `[0.0, 1.0]` to properly fit the frame's size.
                let pointTransform = CGAffineTransform(scaleX: frameSize.width,
                                                       y: frameSize.height)

                guard let poses = poses else { return }

                // Draw all the poses Vision found in the frame.
                for pose in poses {
                    // Draw each pose as a wireframe at the scale of the image.
                    pose.drawWireframeToContext(cgContext, applying: pointTransform)
                }
            }

            // Update the UI's full-screen image view on the main thread.
        
            DispatchQueue.main.async {
                self.dataModel.imageView.image = frameWithPosesRendering
                self.dataModel.lastFrames.append(frameWithPosesRendering)
                if self.dataModel.lastFrames.count > 48 {
                    self.dataModel.lastFrames.remove(at: 0)
                }
                /// this saves video that can be played back
                if self.dataModel.predictionText == "Form"{
                    if self.dataModel.previousPrediction != "Form"{
//                        self.dataModel.formShootingFrames.append([])
                        self.dataModel.formShootingFrames.append(self.dataModel.lastFrames)
                    }
                    self.dataModel.formShootingFrames[self.dataModel.formShootingFrames.count - 1].append(frameWithPosesRendering)
                }
                self.dataModel.previousPrediction = self.dataModel.predictionText
            }
        }
    
    }
}
