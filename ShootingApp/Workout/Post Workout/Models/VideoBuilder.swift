//
//  VideoBuilder.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import SwiftUI
import AVKit
import FirebaseStorage


class VideoBuilder {
    
    static func saveVideoToFirebase(videoURL: URL, videoTitle: String) {
        // File located on disk
        print("SAVE VIDEO")
        let localFile = videoURL

        // Create a reference to the file you want to upload
        let videosRef = storageRef.child("\(currentSignedInUser!.uid)/\(videoTitle)")

        // Upload the file to the path "images/rivers.jpg"
        let uploadTask = videosRef.putFile(from: localFile, metadata: nil) { metadata, error in
          guard let metadata = metadata else {
            // Uh-oh, an error occurred!
              print("there is a huge error")
            return
          }
          // Metadata contains file metadata such as size, content-type.
          let size = metadata.size
          // You can also access to download URL after upload.
          videosRef.downloadURL { (url, error) in
            guard let downloadURL = url else {
              // Uh-oh, an error occurred!
              return
            }
          }
        }
    }


    static func buildVideoFromImageArray(framesArray:[UIImage]){
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
                    saveVideoToFirebase(videoURL: videoOutputURL, videoTitle: UUID().uuidString)
                }
             })
            
         }
    }
}
