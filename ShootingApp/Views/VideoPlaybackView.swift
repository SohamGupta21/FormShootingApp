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

struct VideoPlaybackView: View {
    var currentUser = Auth.auth().currentUser
    @State var currentVideo : URL = URL(string: "path/to/image")!
    @State var videos : [URL] = []
    
    init(){
        let userVideosRef = Storage.storage().reference().child("\(self.currentUser!.uid)/54F0EF39-32C8-4BBD-B9BA-F9F0D80CA019.mp4")
        // Download to the local filesystem
        let downloadTask = userVideosRef.write(toFile: currentVideo) { url, error in
          if let error = error {
            // Uh-oh, an error occurred!
          } else {
            // Local file URL for "images/island.jpg" is returned
          }
        }
    }
    var body: some View {
        VStack{
            VideoPlayerURLController(videoURL: currentVideo)
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
