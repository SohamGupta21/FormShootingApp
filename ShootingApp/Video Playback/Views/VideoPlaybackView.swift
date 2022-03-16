//
//  VideoPlaybackView.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import Foundation
import SwiftUI

struct VideoPlaybackView: View {
    @StateObject var videoPlaybackViewModel = VideoPlaybackModel()
    @State private var isLoading = true
    
    @State var video1 : Video
    @State var video2 : Video
    
    @State var url1 : String = ""
    @State var url2 : String = ""
    
    var body: some View {
        ZStack {
            VStack{
                if !isLoading{
                    URLVideoPlayerView(videoURL: URL(string: url1)!)
                    URLVideoPlayerView(videoURL: URL(string: url2)!)
                }

                Button(action: {print(videoPlaybackViewModel.currentVideo.absoluteString)}, label: {Text("Hello")})
            }
            
            if isLoading {
                ZStack {
                    Color(.systemBackground)
                        .ignoresSafeArea()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .orange))
                        .scaleEffect(5)
                }
            }
            
        }
        .onAppear(perform: {
            setUpURLS(path1: video1.url , path2: video2.url)
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                if url1 != "" && url2 != "" {
                    isLoading = false
                    timer.invalidate()
                }
            }
            

        })
    }
    
    func setUpURLS(path1: String, path2: String){
        let videosReference1 = storageRef.child("vC7gxPGNf1RqNPewHnxGIrpRebK2/\(path1)")
        // Fetch the download url
        var answer1 = ""
        
        videosReference1.downloadURL(completion: { url, error in
          if let error = error {
            print("THIS IS AN ERRORRRRRR: \(error)")
          } else {
              answer1 = url!.absoluteString
              
              url1 = answer1
          }})
        
        
        let videosReference2 = storageRef.child("vC7gxPGNf1RqNPewHnxGIrpRebK2/\(path2)")
        // Fetch the download url
        var answer2 = ""
        
        videosReference2.downloadURL(completion: { url, error in
          if let error = error {
            print("THIS IS AN ERRORRRRRR: \(error)")
          } else {
              answer2 = url!.absoluteString
              
              url2 = answer2
          }})
    }
}
