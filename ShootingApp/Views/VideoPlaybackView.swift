//
//  VideoPlaybackView.swift
//  ShootingApp
//
//  Created by soham gupta on 7/31/21.
//

import SwiftUI
import AVKit
import FirebaseStorage
import FirebaseAuth


class VideoPlaybackModel: ObservableObject {
    @Published var currentUser = Auth.auth().currentUser
    @Published var currentVideo : URL = URL(fileURLWithPath: "")
    @Published var videos : [URL] = []
    @Published var videoNames : [String] = []
    
    init(){
        let videosReference = storageRef.child("C3OLmLkb8RevYUOSx0X2xIm8l0U2/54F0EF39-32C8-4BBD-B9BA-F9F0D80CA019")
//        // Fetch the download URL
//        videosReference.listAll { (result, error) in
//            if let error = error {
//                print(error)
//            }
//            for prefix in result.prefixes {
//                self.videoNames.append(prefix.fullPath)
//            }
//        }
        // Fetch the download url
        videosReference.downloadURL(completion: { url, error in
          if let error = error {
            print(error)
          } else {
            self.currentVideo = url!
          }})
    }
}
struct VideoPlaybackView: View {
    @ObservedObject var videoPlaybackModel : VideoPlaybackModel = VideoPlaybackModel()
    var body: some View {
        VStack{
            VideoPlayerURLController(videoURL: videoPlaybackModel.currentVideo)
        }
    }
}

struct VideoPlayerURLController: UIViewControllerRepresentable {
    typealias UIViewControllerType = AVPlayerViewController
    var videoURL: URL
    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
     
        playerViewController.player = player
     
        return playerViewController
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        
    }
}
