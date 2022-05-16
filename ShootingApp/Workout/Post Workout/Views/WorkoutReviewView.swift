//
//  FormReviewController.swift
//  ShootingApp
//
//  Created by soham gupta on 7/30/21.
//

import SwiftUI
import AVKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

let storage = Storage.storage()
        
let storageRef = storage.reference()

var currentSignedInUser = Auth.auth().currentUser

struct WorkoutReviewView: View {
    
    @State var currentVideo : [UIImage]
    @State var formShootingFrames : [[UIImage]]
    @State var videosToSave: [[UIImage]] = []
    @State var posesPerFrame : [[Pose]]
    @State var formAnalysis : FormAnalysis
    
    @State var isToggle : Bool = false
    
    @ObservedObject var workoutViewModel : WorkoutViewModel

    var body: some View{
        VStack{
            VideoPlayerView(frames: currentVideo)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
            ScrollView(.vertical, showsIndicators: true) {
                Toggle(isOn: $isToggle){
                    Text("Toggle Feedback Type")
                        .foregroundColor(Color.orange)
                }
                if isToggle {
                    AngleComparisonView(formAnalysis: self.formAnalysis)
                        .padding()
                        .cornerRadius(5)
                } else {
                    VerbalFeedbackView(fA: self.formAnalysis, wVM: self.workoutViewModel)
                }
            }
            ScrollView (.horizontal, showsIndicators: false) {
                 HStack {
                    ForEach((0...formShootingFrames.count - 1), id: \.self) { frameIndex in
                        Button(action: {
                            currentVideo = formShootingFrames[frameIndex]
                            self.formAnalysis = FormAnalysis(posesArray: posesPerFrame[frameIndex])
                        }, label: {
                            ZStack{
                                VStack{
                                    Image(uiImage:formShootingFrames[frameIndex][0])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .cornerRadius(10)
                                }
                            }
                        })
                    }
                 }
            }
            .frame(height: 100)
            .padding()
            Spacer()
            
            HStack{
                Button(action:{
                    videosToSave.append(currentVideo)
                },label:{
                    Text("Save Video")
                })
                Spacer()
                Button(action:{
                    self.setIdealAngles()
                }, label: {
                    Text("Save Shot Information")
                })
                Spacer()
                Button(action:{
                    for video in videosToSave {
                        print("Building Video From Image Array")
                        VideoBuilder.buildVideoFromImageArray(framesArray: video)
                    }
                },label:{
                    Text("Done")
                })
            }
            .padding()
            // figure out when it is moving forward and backward and when the motion changes, measure the angle that you need (for example, the second that it starts moving forward, then you know that it is time to measure the angle)
        }
        
    }
    
    func setIdealAngles(){
        let docRef = Firestore.firestore().collection("users").document(currentSignedInUser?.uid ?? "")
        
        let ideal_angle_information = [
            ["left_arm" : Int(self.formAnalysis.leftArmAngle)],
            ["left_leg" : Int(self.formAnalysis.leftLegAngle)],
            ["right_arm" : Int(self.formAnalysis.rightArmAngle)],
            ["right_leg" : Int(self.formAnalysis.rightLegAngle)]
        ]
        docRef.updateData([
            "ideal_angle": ideal_angle_information
        ])
        
    }
}
