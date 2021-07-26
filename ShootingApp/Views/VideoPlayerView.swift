//
//  VideoPlayerView.swift
//  ShootingApp
//
//  Created by soham gupta on 7/19/21.
//

import SwiftUI
import AVKit
struct VideoPlayerView: View {
    @ObservedObject var dataModel: DataModel
    
    var body: some View {
        Text("\(dataModel.frames.count)")
        VideoPlayer(player: AVPlayer(url:URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4")!))
    }
    //VideoConverter().buildVideoFromImageArray(framesArray: dataModel.frames)
}

//struct VideoPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoPlayerView()
//    }
//}
