//
//  WorkoutViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import SwiftUI
import AVKit

class WorkoutViewModel : ObservableObject {
    //communicates with the prediction delegate
    @Published var predictionText : String
    @Published var confidenceText : String
    @Published var previousPrediction : String
    // manages the video playing and frame collection
    @Published var videoCapture : VideoCapture
    @Published var videoProcessingChain : VideoProcessingChain
    @Published var actionFrameCounts : [String: Int]
    // manages the video playback that occurs after the prediction
    @Published var imageView : UIImageView
    @Published var player : AVPlayer
    // collects frames that can be used to make and playback videos
    @Published var formShootingFrames : [[UIImage]]
    @Published var lastFrames : [UIImage]
    @Published var posesPerFrame : [[Pose]]
    @Published var lastPoses : [Pose]
    
    init(){
        
        predictionText = ""
        confidenceText = ""
        previousPrediction = ""
        
        videoCapture = VideoCapture()
        videoProcessingChain = VideoProcessingChain()
        actionFrameCounts = [String: Int]()
        
        imageView = UIImageView()
        player = AVPlayer()
        
        formShootingFrames = []
        lastFrames = []
        posesPerFrame = []
        
        lastPoses = []
    }
    
}
