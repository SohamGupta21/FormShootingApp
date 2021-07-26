//
//  MainScreen.swift
//  ShootingApp
//
//  Created by soham gupta on 4/20/21.
//

import SwiftUI
import FirebaseFirestore

struct MainScreen: View {
    @Binding var groups: [Group]
    @State private var isPresented = false
    @State private var newGroupData = Group.Data()
    @ObservedObject var groupViewModel:GroupViewModel
    @ObservedObject var userViewModel: UserViewModel
    var body: some View {
        TabView {
            HomeScreen(groups: .constant(Group.data),groupViewModel: GroupViewModel(), userViewModel: UserViewModel())
             .tabItem {
                Image(systemName: "house.fill")
                Text("Home")
              }
           BodyPredictionScreen()
             .tabItem {
                Image(systemName: "bolt.horizontal.circle.fill")
                Text("Second Tab")
              }
        }
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen(groups: .constant(Group.data),groupViewModel: GroupViewModel(), userViewModel: UserViewModel())
    }
}
