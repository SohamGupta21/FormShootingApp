//
//  EntryView.swift
//  ShootingApp
//
//  Created by soham gupta on 8/6/21.
//

import SwiftUI
import Firebase

struct EntryView: View {
    @StateObject var entryViewModel = EntryViewModel()
    var colors = Colors()
    var body: some View {
        if entryViewModel.status{
            TabView{
                HomeScreen()
                    .onAppear(perform: setBackgroundColor)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }
                WorkoutEntryView()
                    .tabItem {
                        Label("Workout", systemImage:"play.fill")
                    }
                Text("Quick Improvement")
                    .tabItem {
                        Label("Improve", systemImage: "camera.fill")
                    }
                Text("Statistics")
                    .tabItem{
                        Label("Stats", systemImage:"chart.bar.fill")
                    }
            }
            .accentColor(colors.orangeColor)
            .ignoresSafeArea(.all)
        } else {
            VStack{
                ZStack{
                    NavigationLink(destination: SignUp(show: $entryViewModel.show),isActive: $entryViewModel.show){
                    Text("Error is occuring at the moment, sorry")
                }
                .hidden()
                    LoginView(show: $entryViewModel.show)
                }
            }
            .onAppear() {
                entryViewModel.addObserver()
            }
        }
    }
}

func setBackgroundColor() -> Void {
    UINavigationBar.appearance().backgroundColor = UIColor.black
}


struct EntryView_Previews : PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
