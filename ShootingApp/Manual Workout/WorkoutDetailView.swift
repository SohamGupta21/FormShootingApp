//
//  WorkoutDetailView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/4/22.
//

import SwiftUI

struct WorkoutDetailView: View {
    
    var shots = [
        "10 - Right Hand Layups",
        "10 - Left Hand Layups",
        "10 - Free Throws",
        "!5 - Right Corner Three Pointers",
        "15 - Right Wing Three Pointers",
        "15 - Top of the Key Three Pointers",
        "15 - Left Wing Three Pointers",
        "15 - Left Corner Three Pointers",
        "3 - Half Court Shots"
    ]
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("The Curry Special")
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
            
            Button(action:{}, label:{
                Text("View Summary Diagram")
                    .foregroundColor(Color.orange)
            })
            
            NavigationButton(destContent: {}, text: "Next")
        }
        .padding(.bottom)
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView()
    }
}
