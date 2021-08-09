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
    var body: some View {
        VStack{
            URLVideoPlayerView(videoURL: videoPlaybackViewModel.currentVideo)
        }
    }
}
