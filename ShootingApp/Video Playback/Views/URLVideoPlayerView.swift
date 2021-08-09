//
//  URLVideoPlayerView.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import UIKit
import AVKit
import SwiftUI

struct URLVideoPlayerView: UIViewControllerRepresentable {
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
