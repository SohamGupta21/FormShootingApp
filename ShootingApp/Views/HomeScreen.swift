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
    @Binding var groups: [Group]
    @State private var isPresented = false
    @State private var newGroupData = Group.Data()
    @ObservedObject var groupViewModel:GroupViewModel
    @ObservedObject var userViewModel: UserViewModel
    let db = Firestore.firestore()
    var body: some View {
        VStack{
            HStack{
                NavigationLink(destination: BodyPredictionScreen(), label:{
                    Text("Body Prediction Screen")
                })
                Spacer()
                NavigationLink(destination: VideoPlaybackView(), label:{
                    Text("Video Playback View")
                })
            }
            .padding()
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
                    print("Log out")
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
    private func binding(for group: Group) -> Binding<Group> {
        guard let groupIndex = groups.firstIndex(where: { $0.name == group.name }) else {
            fatalError("Can't find group in array")
        }
        return $groups[groupIndex]
    }
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeScreen(groups: .constant(Group.data),groupViewModel: GroupViewModel(), userViewModel: UserViewModel())
        }
    }
}
