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
    @State private var url1 = ""
    var body: some View {
        ZStack {
            VStack{
                if !isLoading{
                    URLVideoPlayerView(videoURL: videoPlaybackViewModel.currentVideo)
                    URLVideoPlayerView(videoURL: URL(string: url1)!)
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
            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
                print("running timer")
                let freedSpaceString = videoPlaybackViewModel.currentVideo.absoluteString.filter {!$0.isWhitespace}
                if freedSpaceString != "file:///" {
                    
                    print(freedSpaceString == "https://firebasestorage.googleapis.com/v0/b/basketballapp-47ee1.appspot.com/o/C3OLmLkb8RevYUOSx0X2xIm8l0U2%2F54F0EF39-32C8-4BBD-B9BA-F9F0D80CA019?alt=media&token=e4fab955-536a-40b8-92b2-45f666eae181")
                    url1 = freedSpaceString
                    isLoading = false
                    timer.invalidate()
                }
            }

        })
    }
    
    func networkCall() {
        isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isLoading = false
        }
    }
}
