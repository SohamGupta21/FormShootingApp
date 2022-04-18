//
//  ManualWorkoutCreateView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/17/22.
//

import SwiftUI

struct ManualWorkoutCreateView: View {
    @ObservedObject var manualWorkoutViewModel : ManualWorkoutViewModel
    
    @State var workoutBeingCreated : Workout = Workout()
    
    @State var workoutName = ""
    
    @State var drillName = ""
    @State var drillAmount = ""
    var body: some View {
        List {
            Section(header: Text("Workout Info")) {
                TextField("Name", text: $workoutName)
                ForEach(workoutBeingCreated.drills) { drill in
                    Text("\(drill.amount) - \(drill.name)")
                }
            }
            
            Section(header: Text("Add Drill")) {
                TextField("Drill Name", text: $drillName)
                TextField("Reps", text: $drillAmount)
                    .keyboardType(.numberPad)
                Button(action: {
                    workoutBeingCreated.drills.append(Drill(name: drillName, amount: Int(drillAmount) ?? 0))
                    drillName = ""
                    drillAmount = ""
                }, label: {
                    Text("Add Drill")
                })
            }

            Button(action: {
                workoutBeingCreated.name = workoutName
                manualWorkoutViewModel.createNewWorkout(workout : workoutBeingCreated)
            }, label: {
                Text("Submit")
            })
        }
        .listStyle(InsetGroupedListStyle())
    }
}
