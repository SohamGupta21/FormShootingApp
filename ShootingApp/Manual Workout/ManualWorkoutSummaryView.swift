//
//  ManualWorkoutSummaryView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/4/22.
//

import SwiftUI

struct ManualWorkoutSummaryView: View {
    
    @ObservedObject var manualWorkoutViewModel : ManualWorkoutViewModel
    
    var workout : Workout
    
    var shots : [String] = [
//        "9/10 - Right Hand Layups",
//        "10/20 - Left Hand Layups",
//        "2/13 - Free Throws",
//        "5/24 - Right Corner Three Pointers",
//        "7/9 - Right Wing Three Pointers",
//        "10/19 - Top of the Key Three Pointers",
//        "12/23 - Left Wing Three Pointers",
//        "14/15 - Left Corner Three Pointers",
//        "1/3 - Half Court Shots"
    ]
    
    init(workout : Workout, manualWorkoutViewModel : ManualWorkoutViewModel) {
        self.workout = workout
        self.manualWorkoutViewModel = manualWorkoutViewModel
        
        for drill in workout.drills {
            shots.append("\(drill.amount) - \(drill.name)")
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
    
            NavigationButton(destContent: {
                InWorkoutView(workout: self.workout, manualWorkoutViewModel: manualWorkoutViewModel)
            }, text: "Next")
        }
        .padding(.bottom)
    }
}
//
//struct ManualWorkoutSummaryView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManualWorkoutSummaryView()
//    }
//}
