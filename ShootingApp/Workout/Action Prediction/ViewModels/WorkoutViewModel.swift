//
//  WorkoutViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import SwiftUI
import AVKit
import FirebaseAuth
import FirebaseFirestore

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
    
    // for the feedback sentences
    @Published var leftArmText = ""
    @Published var leftLegText = ""
    @Published var rightArmText = ""
    @Published var rightLegText = ""
    
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
    
    func retrieveIdealAngles(fA : FormAnalysis){
        var leftArmIdealAngle : Int = 0
        var leftLegIdealAngle : Int = 0
        var rightArmIdealAngle : Int = 0
        var rightLegIdealAngle : Int = 0
        
        let docRef = Firestore.firestore().collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                let ideal_angles = dataDescription["ideal_angle"] as! [[String : Int]]
                leftArmIdealAngle = ideal_angles[0]["left_arm"] ?? 0
                leftLegIdealAngle = ideal_angles[1]["left_leg"] ?? 0
                rightArmIdealAngle = ideal_angles[2]["right_arm"] ?? 0
                rightLegIdealAngle = ideal_angles[3]["right_leg"] ?? 0
                
                print(rightLegIdealAngle)
                self.updateMessageData(leftArmAngle: leftArmIdealAngle, leftLegAngle: leftLegIdealAngle, rightArmAngle: rightArmIdealAngle, rightLegAngle: rightLegIdealAngle, formAnalysis: fA)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func updateMessageData(leftArmAngle: Int, leftLegAngle: Int, rightArmAngle: Int, rightLegAngle: Int, formAnalysis : FormAnalysis) {
        if (leftArmAngle < Int(formAnalysis.leftArmAngle) - 10) {
            self.leftArmText = "Lower your left hand."
        } else if (leftArmAngle > Int(formAnalysis.leftArmAngle) + 10) {
            self.leftArmText = "Raise your left hand."
        } else {
            self.leftArmText = "Your left hand looks good!"
        }
        
        if (leftLegAngle < Int(formAnalysis.leftLegAngle) - 10) {
            self.leftLegText = "Lower your left leg."
        } else if (leftLegAngle > Int(formAnalysis.leftLegAngle) + 10) {
            self.leftLegText = "Raise your left leg."
        } else {
            self.leftLegText = "Your left leg looks good!"
        }
        
        if (rightArmAngle < Int(formAnalysis.rightArmAngle) - 10) {
            self.rightArmText = "Lower your right arm."
        } else if (rightArmAngle > Int(formAnalysis.rightArmAngle) + 10) {
            self.rightArmText = "Raise your right arm."
        } else {
            self.rightArmText = "Your right arm looks good!"
        }
        
        if (rightLegAngle < Int(formAnalysis.rightLegAngle) - 10) {
            self.rightLegText = "Lower your right leg."
        } else if (rightLegAngle > Int(formAnalysis.rightLegAngle) + 10) {
            self.rightLegText = "Raise your right leg."
        } else {
            self.rightLegText = "Your right leg looks good!"
        }
        print(leftArmText)
    }
    
}
