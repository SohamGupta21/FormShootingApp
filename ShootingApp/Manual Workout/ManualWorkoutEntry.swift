//
//  ManualWorkoutEntry.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/1/22.
//

import SwiftUI

struct ManualWorkoutEntry: View {
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
                        ForEach(0..<10) { index in
                            WorkoutInformationTag()
                        }.padding()
                    }
                }
                SectionView(title: "Team Workouts")
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(0..<10) { index in
                            WorkoutInformationTag()
                        }.padding()
                    }
                }
                SectionView(title: "Workout Challenges")
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(0..<10) { index in
                            WorkoutInformationTag()
                        }.padding()
                    }
                }
                Spacer()
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
