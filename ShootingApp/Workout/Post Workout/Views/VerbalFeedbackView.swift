//
//  VerbalFeedbackView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 5/15/22.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct VerbalFeedbackView: View {
    var colors = Colors()
    var formAnalysis : FormAnalysis

    @ObservedObject var workoutViewModel : WorkoutViewModel
    
    init(fA : FormAnalysis, wVM: WorkoutViewModel){
        self.formAnalysis = fA
        self.workoutViewModel = wVM
        
        self.workoutViewModel.retrieveIdealAngles(fA: fA)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Tips")
                    .font(.title)
            }
            .padding()
            HStack {
                Text("Raise your left arm higher")
                //Text("• \(workoutViewModel.leftArmText)")
                Spacer()
            }
            .padding()
            HStack {
                Text("Bend your left leg more")
                //Text("• \(workoutViewModel.leftLegText)")
                Spacer()
            }
            .padding()
            HStack {
                Text("Your right arm looks good")
                //Text("• \(workoutViewModel.rightArmText)")
                Spacer()
            }
            .padding()
            HStack {
                Text("Bend your right leg more")
                //Text("• \(workoutViewModel.rightLegText)")
                Spacer()
            }
            .padding()
        }
    }
}

