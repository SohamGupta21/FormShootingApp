//
//  HomeScreen.swift
//  ShootingApp
//
//  Created by soham gupta on 5/29/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import SwiftUICharts

struct HomeScreen: View {
    @State private var isPresented = false
    let db = Firestore.firestore()
    let colors = Colors();
    
    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]

        //Use this if NavigationBarTitle is with displayMode = .inline
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
        
        
    }
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [colors.orangeColor, colors.greyColor, colors.greyColor]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.bottom)
           VStack{
               Heading("Improve Your Form")
               
               NavigationButton(destContent:{VideoPlaybackView()}, text:"Video Playback View")
               
              Heading("Get Your Reps In")
            
               
               NavigationButton(destContent: {WorkoutEntryView()}, text: "Start A New Workout")
               
               Heading("Check Your Stats")
               
               // Bar Chart
               BarChartView(data: ChartData(values: [
                ("S", 23),
                ("M", 126),
                ("T", 54),
                ("W", 234),
                ("Th", 435),
                ("F", 230),
                ("Sat", 356)]), title: "Your Progress", legend:"Shots Taken", form:ChartForm.medium)

           }
       }
    }
}

struct HomeScreen_Previews : PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

