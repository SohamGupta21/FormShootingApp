//
//  EntryView.swift
//  ShootingApp
//
//  Created by soham gupta on 8/6/21.
//

import SwiftUI
import Firebase

struct EntryView: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    var colors = Colors()
    var body: some View {
        NavigationView {
            VStack{
                if self.status{
                    TabView{
                        HomeScreen()
                            .onAppear(perform: setBackgroundColor)
                            .navigationBarTitleDisplayMode(.inline)
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        
                        ManualWorkoutEntry()
                            .onAppear(perform: setBackgroundColor)
                        .tabItem {
                            Label("Workout", systemImage: "sportscourt")
                        }
                        
//                        WorkoutEntryView()
//                            .onAppear(perform: setBackgroundColor)
//                        .tabItem {
//                            Label("Workout", systemImage: "waveform.path.ecg")
//                        }
//
//                        TeamsHomeView()
//                            .onAppear(perform: {
//                                setBackgroundColor()
//                            })
//                        .tabItem {
//                            Label("Teams", systemImage: "person.3.fill")
//                        }
//
//                        VideoComparisonChooseScreen()
//                        .tabItem {
//                            Label("Fix your shot", systemImage:"wrench.and.screwdriver.fill")
//                        }
                       
                        ChartView()
                        .tabItem{
                            Label("Stats", systemImage:"chart.bar.fill")
                        }
                    }
                    .accentColor(colors.orangeColor)
                    .ignoresSafeArea(.all)
                    .navigationTitle("Form")
                    .navigationBarItems(trailing:
                        Button(action:{
                            try! Auth.auth().signOut()
                            UserDefaults.standard.set(false, forKey: "status")
                            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                        self.status = false
                        
                        }){
                            Text("Log Out")
                        }
                    )
                } else {
                    VStack{
                        ZStack{
                            NavigationLink(destination: SignUp(show: self.$show),isActive: self.$show){
                                Text("Error is occuring at the moment, sorry")
                            }
                            .hidden()
                                LoginView(show: self.$show)
                        }
                    }
                    .onAppear() {
                        NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                            self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                        }
                    }
                }
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

