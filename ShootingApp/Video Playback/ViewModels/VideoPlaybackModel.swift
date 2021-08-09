//
//  VideoPlaybackModel.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import Foundation
import FirebaseAuth
import FirebaseStorage

class VideoPlaybackModel: ObservableObject {
    @Published var currentUser = Auth.auth().currentUser
    @Published var currentVideo : URL = URL(fileURLWithPath: "")
    @Published var videos : [URL] = []
    @Published var videoNames : [String] = []
    
    init(){
        let videosReference = storageRef.child("C3OLmLkb8RevYUOSx0X2xIm8l0U2/54F0EF39-32C8-4BBD-B9BA-F9F0D80CA019")
        // Fetch the download url
        videosReference.downloadURL(completion: { url, error in
          if let error = error {
            print("THIS IS AN ERRORRRRRR: \(error)")
          } else {
            self.currentVideo = url!
          }})
    }
}
