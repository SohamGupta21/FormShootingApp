import AVFoundation
import UIKit
import Photos
import AVKit
import SwiftUI

var tempurl=""


struct VideoPlayerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = AVPlayerViewController
    var frames : [UIImage]
    
    func makeUIViewController(context:Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        DispatchQueue.main.async {
            var tempFrames: [UIImage] = []
            
            for i in 0...frames.count - 48 {
                tempFrames.append(frames[i])
            }
            let settings = RenderSettings()
            let imageAnimator = ImageAnimator(renderSettings: settings,imagearr: tempFrames)
            imageAnimator.render() {
                let player = AVPlayer(url: (URL(fileURLWithPath:tempurl)))
                playerViewController.player = player
                print("Temp URL \(tempurl)")
            }
        }
        
         
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        var tempFrames: [UIImage] = []
        
        for i in 0...frames.count - 48 {
            tempFrames.append(frames[i])
        }
        let settings = RenderSettings()
        let imageAnimator = ImageAnimator(renderSettings: settings,imagearr: tempFrames)
        imageAnimator.render() {
            let player = AVPlayer(url: (URL(fileURLWithPath:tempurl)))
            uiViewController.player = player
        }
    }
}


struct RenderSettings {
    // the basic settings
    
    // used to be 1500 by 844
    var width: CGFloat = UIScreen.main.bounds.width
    var height: CGFloat = UIScreen.main.bounds.height
    var fps: Int32 = 30   // 2 frames per second
    var avCodecKey = AVVideoCodecType.h264
    var videoFilename = "renderExportVideo"
    var videoFilenameExt = "mp4"

    var size: CGSize {
        return CGSize(width: width, height: height)
    }
    // gets the file path of the url to play
    var outputURL: NSURL {

        let fileManager = FileManager.default
        if let tmpDirURL = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) {
            return tmpDirURL.appendingPathComponent(videoFilename).appendingPathExtension(videoFilenameExt) as NSURL
        }
        fatalError("URLForDirectory() failed")
    }
}

class VideoWriter {

    let renderSettings: RenderSettings
    // writes media data to a new file for audio visual stuff
    var videoWriter: AVAssetWriter!
    var videoWriterInput: AVAssetWriterInput!
    var pixelBufferAdaptor: AVAssetWriterInputPixelBufferAdaptor!

    var isReadyForData: Bool {
        return videoWriterInput?.isReadyForMoreMediaData ?? false
    }
    //gathers the pixel buffer from the image to create the video
    class func pixelBufferFromImage(image: UIImage, pixelBufferPool: CVPixelBufferPool, size: CGSize) -> CVPixelBuffer {

        var pixelBufferOut: CVPixelBuffer?

        let status = CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, pixelBufferPool, &pixelBufferOut)
        if status != kCVReturnSuccess {
            fatalError("CVPixelBufferPoolCreatePixelBuffer() failed")
        }

        let pixelBuffer = pixelBufferOut!

        CVPixelBufferLockBaseAddress(pixelBuffer, [])

        let data = CVPixelBufferGetBaseAddress(pixelBuffer)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: data, width: Int(size.width), height: Int(size.height),
                                bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue)

        context!.clear(CGRect(x: 0, y: 0, width: size.width, height: size.height))

        let horizontalRatio = size.width / image.size.width
        let verticalRatio = size.height / image.size.height

        let aspectRatio = min(horizontalRatio, verticalRatio) // ScaleAspectFit

        let newSize = CGSize(width: image.size.width * aspectRatio, height: image.size.height * aspectRatio)

        let x = newSize.width < size.width ? (size.width - newSize.width) / 2 : 0
        let y = newSize.height < size.height ? (size.height - newSize.height) / 2 : 0

        context!.concatenate(CGAffineTransform.identity)
        context!.draw(image.cgImage!, in: CGRect(x: x, y: y, width: newSize.width, height: newSize.height))

        CVPixelBufferUnlockBaseAddress(pixelBuffer, [])

        return pixelBuffer
    }

    init(renderSettings: RenderSettings) {
        self.renderSettings = renderSettings
    }

    func start() {
        // configures settings
        let avOutputSettings: [String: AnyObject] = [
            AVVideoCodecKey: renderSettings.avCodecKey as AnyObject,
            AVVideoWidthKey: NSNumber(value: Float(renderSettings.width)),
            AVVideoHeightKey: NSNumber(value: Float(renderSettings.height))
        ]
        // combines pixel buffers
        func createPixelBufferAdaptor() {
            let sourcePixelBufferAttributesDictionary = [
                kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32ARGB),
                kCVPixelBufferWidthKey as String: NSNumber(value: Float(renderSettings.width)),
                kCVPixelBufferHeightKey as String: NSNumber(value: Float(renderSettings.height))
            ]
            pixelBufferAdaptor = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput,
                                                                      sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
        }

        func createAssetWriter(outputURL: NSURL) -> AVAssetWriter {
            guard let assetWriter = try? AVAssetWriter(outputURL: outputURL as URL, fileType: AVFileType.mp4) else {
                fatalError("AVAssetWriter() failed")
            }

            guard assetWriter.canApply(outputSettings: avOutputSettings, forMediaType: AVMediaType.video) else {
                fatalError("canApplyOutputSettings() failed")
            }

            return assetWriter
        }

        videoWriter = createAssetWriter(outputURL: renderSettings.outputURL)
        videoWriterInput = AVAssetWriterInput(mediaType: AVMediaType.video, outputSettings: avOutputSettings)

        if videoWriter.canAdd(videoWriterInput) {
            videoWriter.add(videoWriterInput)
        }
        else {
            fatalError("canAddInput() returned false")
        }


        createPixelBufferAdaptor()

        if videoWriter.startWriting() == false {
            fatalError("startWriting() failed")
        }

        videoWriter.startSession(atSourceTime: CMTime.zero)

        precondition(pixelBufferAdaptor.pixelBufferPool != nil, "nil pixelBufferPool")
    }

    func render(appendPixelBuffers: @escaping (VideoWriter)->Bool, completion: @escaping ()->Void) {

        precondition(videoWriter != nil, "Call start() to initialze the writer")

        let queue = DispatchQueue(label: "mediaInputQueue")
        videoWriterInput.requestMediaDataWhenReady(on: queue) {
            let isFinished = appendPixelBuffers(self)
            if isFinished {
                self.videoWriterInput.markAsFinished()
                self.videoWriter.finishWriting() {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
            else {

            }
        }
    }

    func addImage(image: UIImage, withPresentationTime presentationTime: CMTime) -> Bool {

        precondition(pixelBufferAdaptor != nil, "Call start() to initialze the writer")

        let pixelBuffer = VideoWriter.pixelBufferFromImage(image: image, pixelBufferPool: pixelBufferAdaptor.pixelBufferPool!, size: renderSettings.size)
        return pixelBufferAdaptor.append(pixelBuffer, withPresentationTime: presentationTime)
    }

}

class ImageAnimator{

    static let kTimescale: Int32 = 600

    let settings: RenderSettings
    let videoWriter: VideoWriter
    var images: [UIImage]!

    var frameNum = 0

    class func removeFileAtURL(fileURL: NSURL) {
        do {
            try FileManager.default.removeItem(atPath: fileURL.path!)
        }
        catch _ as NSError {
            //
        }
    }

    init(renderSettings: RenderSettings, imagearr: [UIImage]) {
        settings = renderSettings
        videoWriter = VideoWriter(renderSettings: settings)
        images = imagearr
    }
    //gets the url ready for playing and then runs the function as soon as it is done
    
    func render(completion: @escaping ()->Void) {

        // The VideoWriter will fail if a file exists at the URL, so clear it out first.
        ImageAnimator.removeFileAtURL(fileURL: settings.outputURL)

        videoWriter.start()
        videoWriter.render(appendPixelBuffers: appendPixelBuffers) {

            let s:String=self.settings.outputURL.path!

            tempurl=s
            completion()
        }

    }


    func appendPixelBuffers(writer: VideoWriter) -> Bool {

        let frameDuration = CMTimeMake(value: Int64(ImageAnimator.kTimescale / settings.fps), timescale: ImageAnimator.kTimescale)

        while !images.isEmpty {

            if writer.isReadyForData == false {

                return false
            }

            let image = images.removeFirst()
            let presentationTime = CMTimeMultiply(frameDuration, multiplier: Int32(frameNum))
            let success = videoWriter.addImage(image: image, withPresentationTime: presentationTime)
            if success == false {
                fatalError("addImage() failed")
            }

            frameNum=frameNum+1
        }


        return true
    }

}
