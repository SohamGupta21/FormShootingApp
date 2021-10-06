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
               HStack{
                   Text("Improve Your Form")
                       .font(.title2)
                       .foregroundColor(colors.whiteColor)
                       .cornerRadius(50)
                   Spacer()
               }
               .padding()
               
               NavigationLink(destination: VideoPlaybackView(), label:{
                   Text("Video Playback View")
                       .foregroundColor(colors.whiteColor)
                       .foregroundColor(.white)
                       .padding(.vertical)
                       .frame(width: UIScreen.main.bounds.width - 50)
               })
               .background(colors.orangeColor)
               .cornerRadius(50)
               .padding(.top, 25)
               
               HStack{
                   Text("Get Your Reps In")
                       .font(.title2)
                       .foregroundColor(colors.whiteColor)
                       .cornerRadius(50)
                   Spacer()
               }
               .padding()
               NavigationLink(destination: WorkoutEntryView(), label:{
                   Text("Start a New Workout")
                       .foregroundColor(.white)
                       .padding(.vertical)
                       .frame(width: UIScreen.main.bounds.width - 50)
               })
               .background(colors.orangeColor)
               .cornerRadius(50)
               .padding(.top, 25)
               HStack{
                   Text("Check Your Stats")
                       .font(.title2)
                       .foregroundColor(colors.whiteColor)
                       .cornerRadius(50)
                   Spacer()
               }
               .padding()
               
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
           .navigationTitle("Home")
           .navigationBarTitleDisplayMode(.inline)
           .navigationBarItems(trailing:
               HStack{
                   
               }
           )
           .navigationBarItems(leading:
               HStack{
                   Image(systemName: "list.dash")
                   .foregroundColor(colors.greyColor)
               Button(action: {
                   try! Auth.auth().signOut()
                   UserDefaults.standard.set(false, forKey: "status")
                   NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
               }) {
                   Image(systemName: "person.crop.circle")
                       .foregroundColor(colors.greyColor)
               }
               Spacer()
               Image(systemName: "gearshape.fill")
               .foregroundColor(colors.greyColor)
               }
           )
       }
    }
}

struct HomeScreen_Previews : PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

