//
//  WorkoutEntryView.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import SwiftUI
import AVFoundation
import Vision
import AVKit
import Photos

struct WorkoutEntryView: View {
    @StateObject var workoutViewModel = WorkoutViewModel()
    @State var cameraRunning = true
    var body: some View {
        if cameraRunning {
            ActiveWorkoutView(workoutViewModel: workoutViewModel, cameraRunning: self.$cameraRunning)
        } else {
            WorkoutReviewView(currentVideo: workoutViewModel.formShootingFrames[0], formShootingFrames: workoutViewModel.formShootingFrames, formAnalysis: FormAnalysis(posesArray: workoutViewModel.posesPerFrame[0]))
        }
    }
}
