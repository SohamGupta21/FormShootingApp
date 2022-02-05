//
//  ActiveWorkoutView.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import SwiftUI
import AVKit
import Photos


struct ActiveWorkoutView : View {
    @ObservedObject var workoutViewModel : WorkoutViewModel
    @Binding var cameraRunning : Bool
    @State var alertShowing = true
    var body : some View {
        ZStack{
            CameraStreamView(workoutViewModel: workoutViewModel)
                .aspectRatio(contentMode: .fill)
            VStack{
                HStack {
                    Button(action:{
                    }, label:{
                        Image(systemName: "camera")
                    })
                    Spacer()
                }
                Spacer()
                VStack{
                    Text(workoutViewModel.predictionText)
                        .font(.custom("Helvetica Neue", size: 40))
                        .foregroundColor(.black)
                    Text("\(workoutViewModel.confidenceText)")
                        .font(.custom("Helvetica Neue", size: 40))
                        .foregroundColor(.black)
                }
                .background(Color.gray)
                .cornerRadius(10)
                .opacity(0.5)
                Button(action:{
                    if cameraRunning{
                        cameraRunning.toggle()
                    }
                }, label:{
                    ZStack{
                        Text("End Workout")
                    }
                })
                .accessibilityIdentifier("workoutButton")
            }
            .padding()
            
            if alertShowing {
                WorkoutStartPopUpView(alert: self.$alertShowing)
            }
            
        }
//        .sheet(isPresented: self.$alertShowing) {
//            WorkoutStartPopUpView(alert: self.$alertShowing)
//                .padding(.all)
//        }
        .onAppear(perform:{
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .edgesIgnoringSafeArea(.top)
        
    }
}

