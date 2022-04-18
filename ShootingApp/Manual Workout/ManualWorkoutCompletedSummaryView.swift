//
//  ManualWorkoutCompletedSummaryView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/17/22.
//

import SwiftUI

struct ManualWorkoutCompletedSummaryView: View {
    var workout : Workout
    var shots : [String] = []
    
    @ObservedObject var manualWorkoutViewModel : ManualWorkoutViewModel
    
    init(workout : Workout, mWVM : ManualWorkoutViewModel) {
        self.workout = workout
        self.manualWorkoutViewModel = mWVM
        
        for drill in workout.drills {
            shots.append("\(drill.madeBaskets)/\(drill.amount) - \(drill.name)")
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text(workout.name)
                        .fontWeight(.bold)
                        .font(.title)
                }
            }
            .padding()
            
            List {
                ForEach(shots, id: \.self) { item in
                    Text(item)
                }
            }
            
//            Button(action:{}, label:{
//                Text("View Summary Diagram")
//                    .foregroundColor(Color.orange)
//            })
            
            Button(action: {
                // save the data into firestore
                manualWorkoutViewModel.saveWorkouProgressIntoLog(workout: workout)
            }, label: {
                Text("Save Progress")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            })
            .background(Colors().orangeColor)
            .cornerRadius(50)
            .padding(.top, 25)
        }
        .padding(.bottom)
    }
}

