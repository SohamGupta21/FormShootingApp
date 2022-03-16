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

let storage = Storage.storage()
        
let storageRef = storage.reference()

var currentSignedInUser = Auth.auth().currentUser

struct WorkoutReviewView: View {
    
    @State var currentVideo : [UIImage]
    @State var formShootingFrames : [[UIImage]]
    @State var videosToSave: [[UIImage]] = []
    @State var posesPerFrame : [[Pose]]
    @State var formAnalysis : FormAnalysis

    var body: some View{
        VStack{
            VideoPlayerView(frames: currentVideo)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
            ScrollView(.vertical, showsIndicators: true) {
                
                AngleComparisonView(formAnalysis: self.formAnalysis)
                    .padding()
                    .cornerRadius(5)
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
            }
            
            Spacer()
            
            HStack{
                Button(action:{
                    videosToSave.append(currentVideo)
                },label:{
                    Text("Save Video")
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
            Text("Primary Shooting Arm Angle: \(formAnalysis.primaryShootingArmAngle)")
        }
        
    }
}
