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

struct HomeScreen: View {
    @State private var isPresented = false
    let db = Firestore.firestore()
    let colors = Colors();
    var body: some View {
        ZStack{
            Color(colors.greyCGColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                HStack{
                    NavigationLink(destination: WorkoutEntryView(), label:{
                        Text("Workout Entry View")
                            .foregroundColor(colors.whiteColor)
                    })
                    Spacer()
                    NavigationLink(destination: VideoPlaybackView(), label:{
                        Text("Video Playback View")
                            .foregroundColor(colors.whiteColor)
                    })
                }
                .padding()
                Spacer()
                VStack{
                    HStack{
                        Text("Groups")
                        Spacer()
                        Button(action: {
                            isPresented = true
                        }) {
                            Image(systemName: "plus")
                        }
                    }.padding()
                }
            }
            .navigationTitle("Analyze")
            .navigationBarItems(trailing:
                VStack{
                    Button(action: {
                        try! Auth.auth().signOut()
                        UserDefaults.standard.set(false, forKey: "status")
                        NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    }) {
                        Text("Log out")
                    }
                    .padding(.top, 25)
                    Spacer()
                    Image(systemName: "gearshape.fill")
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

