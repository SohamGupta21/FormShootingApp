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
    @State var formAnalysis : FormAnalysis

    var body: some View{
        VStack{
            VideoPlayerView(frames: currentVideo)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            Spacer()
            ScrollView (.horizontal, showsIndicators: false) {
                 HStack {
                    ForEach((0...formShootingFrames.count - 1), id: \.self) { frameIndex in
                        Button(action: {
                            currentVideo = formShootingFrames[frameIndex]
                        }, label: {
                            ZStack{
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.white)
                                    .frame(width: 150, height: 175)
                                VStack{
                                    Image(uiImage:formShootingFrames[frameIndex][0])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                    Text("Shot \(frameIndex + 1)")
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
                    for video in videosToSave {
                        VideoBuilder.buildVideoFromImageArray(framesArray: video)
                    }
                },label:{
                    Text("Done")
                })
            }
            .padding()
            Text("Primary Shooting Arm Angle: \(formAnalysis.primaryShootingArmAngle)")
        }
        
    }
}

