//
//  DataModel.swift
//  ShootingApp
//
//  Created by soham gupta on 7/30/21.
//

import SwiftUI
import AVKit

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
