//
//  ManualWorkoutEntry.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/1/22.
//

import SwiftUI

struct ManualWorkoutEntry: View {
    
    @StateObject var manualWorkoutViewModel : ManualWorkoutViewModel = ManualWorkoutViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    VStack {
                        Text("Start a Workout")
                            .fontWeight(.bold)
                            .font(.title)
                        Text("Let's Get Some Work In")
                            .italic()
                            .font(.title3)
                    }
                }
                .padding()
                
                SectionView(title: "Your Workouts")
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(manualWorkoutViewModel.workouts) { workout in
                            WorkoutInformationTag(workout: workout, manualWorkoutViewModel: manualWorkoutViewModel)
                        }.padding()
                    }
                }
                Spacer()
                NavigationLink (destination: {
                    ManualWorkoutCreateView(manualWorkoutViewModel: manualWorkoutViewModel)
                }, label: {
                    HStack{
                        Image(systemName: "plus")
                        Text("Create New Workout")
                    }
                })
            }
        }
    }
}

struct ManualWorkoutEntry_Previews: PreviewProvider {
    static var previews: some View {
        ManualWorkoutEntry()
    }
}

struct SectionView: View {
    var title : String
    var body : some View {
        HStack{
            Text(title)
                .font(.headline)
            Spacer()
        }
        .padding()
    }
}
