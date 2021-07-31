import SwiftUI
import AVFoundation
import Vision
import AVKit
import Photos

struct BodyPredictionScreen: View {
    @ObservedObject var dataModel = DataModel()
    var body: some View {
        CameraPredictionScreen(dataModel: dataModel)
    }

}

struct CameraPredictionScreen : View {
    @ObservedObject var dataModel : DataModel
    var body : some View {
        if dataModel.cameraRunning{
            ZStack{
                ImageView(dM: dataModel)
                    .aspectRatio(contentMode: .fill)
                VStack{
                    HStack {
                        Button(action:{
                        }, label:{
                            Image(systemName: "camera")
                        })
                        Spacer()
                    }
                    Spacer()

                    VStack{
                        Text(dataModel.predictionText)
                            .font(.custom("Helvetica Neue", size: 40))
                            .foregroundColor(.black)
                        Text("\(dataModel.confidenceText)")
                            .font(.custom("Helvetica Neue", size: 40))
                            .foregroundColor(.black)

                    }
                    .background(Color.gray)
                    .cornerRadius(10)
                    .opacity(0.5)
                    Button(action:{
                        if dataModel.cameraRunning{
                            dataModel.player = buildVideoFromImageArray(framesArray: dataModel.formShootingFrames[0])
                            dataModel.cameraRunning.toggle()
                        }
                    }, label:{
                        Text("CLICK ON ME")
                    })
                }
                .padding()
            }
            .onAppear(perform:{
                UIApplication.shared.isIdleTimerDisabled = true
            })
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
            .edgesIgnoringSafeArea(.top)
        } else {
            FormReviewController(dataModel: dataModel,currentVideo: dataModel.formShootingFrames[0])
            
        }
        
    }
}


struct FormReviewController: View {
    @ObservedObject var dataModel : DataModel
    @State var currentVideo : [UIImage]
    var body: some View{
        VStack{
            VideoPlayerController(frames: currentVideo)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            Spacer()
            ScrollView (.horizontal, showsIndicators: false) {
                 HStack {
                    ForEach((0...dataModel.formShootingFrames.count - 1), id: \.self) { frameIndex in
                        Button(action: {
                            currentVideo = dataModel.formShootingFrames[frameIndex]
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 150, height: 175)
                                VStack{
                                    Image(uiImage:dataModel.formShootingFrames[frameIndex][0])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                    Text("Shot \(frameIndex + 1)")
                                }
                                
                                
                            }
                        })
                    }
                 }
            }
            .frame(height: 100)
            .padding()
            Spacer()
        }
        
    }
}
class DataModel : ObservableObject {
    @Published var predictionText : String
    @Published var confidenceText : String
    @Published var previousPrediction : String
    @Published var videoCapture : VideoCapture
    @Published var videoProcessingChain : VideoProcessingChain
    @Published var actionFrameCounts : [String: Int]
    @Published var imageView : UIImageView
    @Published var formShootingFrames : [[UIImage]]
    @Published var lastFrames : [UIImage]
    @Published var cameraRunning : Bool
    @Published var player : AVPlayer
    init(){
        predictionText = ""
        confidenceText = ""
        previousPrediction = ""
        videoCapture = VideoCapture()
        videoProcessingChain = VideoProcessingChain()
        actionFrameCounts = [String: Int]()
        imageView = UIImageView()
        formShootingFrames = []
        lastFrames = []
        cameraRunning = true
        player = AVPlayer()
    }
}

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

func saveVideoToLibrary(videoURL: URL) {
     
     PHPhotoLibrary.shared().performChanges({
         PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: videoURL)
     }) { saved, error in
         
         if let error = error {
             print("Error saving video to librayr: \(error.localizedDescription)")
         }
         if saved {
             print("Video save to library")
             
         }
     }
}
func buildVideoFromImageArray(framesArray:[UIImage]) -> AVPlayer {
     var images = framesArray
     let outputSize = CGSize(width:images[0].size.width, height: images[0].size.height)
     let fileManager = FileManager.default
     let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
     guard let documentDirectory = urls.first else {
         fatalError("documentDir Error")
     }
     
     let videoOutputURL = documentDirectory.appendingPathComponent("OutputVideo.mp4")
     
     if FileManager.default.fileExists(atPath: videoOutputURL.path) {
         do {
             try FileManager.default.removeItem(atPath: videoOutputURL.path)
         } catch {
             fatalError("Unable to delete file: \(error) : \(#function).")
         }
     }
     
     guard let videoWriter = try? AVAssetWriter(outputURL: videoOutputURL, fileType: AVFileType.mp4) else {
         fatalError("AVAssetWriter error")
     }
     
     let outputSettings = [AVVideoCodecKey : AVVideoCodecType.h264, AVVideoWidthKey : NSNumber(value: Float(outputSize.width)), AVVideoHeightKey : NSNumber(value: Float(outputSize.height))] as [String : Any]
     
     guard videoWriter.canApply(outputSettings: outputSettings, forMediaType: AVMediaType.video) else {
         fatalError("Negative : Can't apply the Output settings...")
     }
     
     let videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: outputSettings)
     let sourcePixelBufferAttributesDictionary = [
         kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_32ARGB),
         kCVPixelBufferWidthKey as String: NSNumber(value: Float(outputSize.width)),
         kCVPixelBufferHeightKey as String: NSNumber(value: Float(outputSize.height))
     ]
     let pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
     
     if videoWriter.canAdd(videoWriterInput) {
         videoWriter.add(videoWriterInput)
     }
     
     if videoWriter.startWriting() {
         videoWriter.startSession(atSourceTime: CMTime.zero)
         assert(pixelBufferAdaptor.pixelBufferPool != nil)
         
         let media_queue = DispatchQueue(__label: "mediaInputQueue", attr: nil)
         
         videoWriterInput.requestMediaDataWhenReady(on: media_queue, using: { () -> Void in
             let fps: Int32 = 30//2
             let frameDuration = CMTimeMake(value: 1, timescale: fps)
             
             var frameCount: Int64 = 0
             var appendSucceeded = true
             
             while (!images.isEmpty) {
                 if (videoWriterInput.isReadyForMoreMediaData) {
                     let nextPhoto = images.remove(at: 0)
                     let lastFrameTime = CMTimeMake(value: frameCount, timescale: fps)
                     let presentationTime = frameCount == 0 ? lastFrameTime : CMTimeAdd(lastFrameTime, frameDuration)
                     
                     var pixelBuffer: CVPixelBuffer? = nil
                     let status: CVReturn = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferAdaptor.pixelBufferPool!, &pixelBuffer)
                     
                     if let pixelBuffer = pixelBuffer, status == 0 {
                         let managedPixelBuffer = pixelBuffer
                         
                         CVPixelBufferLockBaseAddress(managedPixelBuffer, [])
                         
                         let data = CVPixelBufferGetBaseAddress(managedPixelBuffer)
                         let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
                         let context = CGContext(data: data, width: Int(outputSize.width), height: Int(outputSize.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(managedPixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)
                         
                         context?.clear(CGRect(x: 0, y: 0, width: outputSize.width, height: outputSize.height))
                         
                         let horizontalRatio = CGFloat(outputSize.width) / nextPhoto.size.width
                         let verticalRatio = CGFloat(outputSize.height) / nextPhoto.size.height
                         
                         let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit
                         
                         let newSize = CGSize(width: nextPhoto.size.width * aspectRatio, height: nextPhoto.size.height * aspectRatio)
                         
                         let x = newSize.width < outputSize.width ? (outputSize.width - newSize.width) / 2 : 0
                         let y = newSize.height < outputSize.height ? (outputSize.height - newSize.height) / 2 : 0
                         
                         context?.draw(nextPhoto.cgImage!, in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))
                         
                         CVPixelBufferUnlockBaseAddress(managedPixelBuffer, [])
                         
                         appendSucceeded = pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
                         frameCount += 1
                     } else {
                         print("Failed to allocate pixel buffer")
                         appendSucceeded = false
                     }
                 }
                 if !appendSucceeded {
                     break
                 }
                 //frameCount += 1
             }
             videoWriterInput.markAsFinished()
            videoWriter.finishWriting { () -> Void in
                print("Done saving")
                print("OUTPUT URL: \(videoOutputURL.relativeString)")
                saveVideoToLibrary(videoURL: videoOutputURL)
            }
         })
        
     }
    return AVPlayer(url: videoOutputURL)
    
}

