//
//  WorkoutHomeView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 5/15/22.
//

import SwiftUI

struct WorkoutHomeView: View {
    var body: some View {
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
                Spacer()
            }
            .padding()
            
            HStack {
                NavigationLink(destination: {
                    WorkoutEntryView()
                }, label: {
                    WorkoutNavigationButtonView(icon_name: "camera.viewfinder", title: "Video Workout", description: "Use this to record yourself shooting and get live feedback on your performance.")
                })
//
//                NavigationLink(destination: {
//                    VideoComparisonChooseScreen()
//                }, label: {
//                    WorkoutNavigationButtonView(icon_name: "wrench.and.screwdriver", title: "Fix Your Shot")
//                })
            }
            ManualWorkoutEntry()
        }
    }
}

struct WorkoutHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutHomeView()
    }
}


struct WorkoutNavigationButtonView : View {
    
    var icon_name = ""
    var title = ""
    var description = ""
    
    var body : some View {
        HStack {
            Image(systemName: icon_name)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Colors().orangeColor)
            VStack {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                Text(description)
            }
            
                
        }
        .padding()
        .background(Color.white.opacity(0.06))
        .cornerRadius(15)
        .shadow(color: Color.white.opacity(0.2), radius: 10, x: 0, y: 0)
        

    }
}
