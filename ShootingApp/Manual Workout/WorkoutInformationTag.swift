//
//  WorkoutInformationTag.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/4/22.
//

import SwiftUI

struct WorkoutInformationTag : View {
    
    var workout : Workout
    
    @ObservedObject var manualWorkoutViewModel : ManualWorkoutViewModel
    
    var body : some View {
        NavigationLink(destination:{
            ManualWorkoutSummaryView(workout: self.workout, manualWorkoutViewModel: manualWorkoutViewModel)
        }) {
            VStack(alignment: .leading, spacing: 16.0) {
                Image("ball_court")
                    .resizable()
                    .frame(width:150, height:150)
                cardText.padding(.horizontal, 8)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24.0))
            .shadow(radius:8)
        }
    }
    
    var cardText: some View {
        VStack(alignment: .leading) {
            Text(workout.name)
                .font(.headline)
            HStack(spacing: 4.0) {
                Image(systemName: "clock.arrow.circlepath")
                Text("\(workout.drills.count) drills")
            }.foregroundColor(.gray)
                .padding(.bottom, 16)
        }
    }
}

//
//struct WorkoutInformationTag_Previews: PreviewProvider {
//    static var previews: some View {
//        WorkoutInformationTag()
//    }
//}

