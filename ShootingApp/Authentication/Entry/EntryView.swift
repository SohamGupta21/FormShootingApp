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
    
    var body: some View {
        if entryViewModel.status{
            HomeScreen()
        } else {
            VStack{
                ZStack{
                    NavigationLink(destination: SignUpView(show: $entryViewModel.show),isActive: $entryViewModel.show){
                    Text("Error is occuring at the moment, sorry")
                }
                .hidden()
                    LoginView(show: $entryViewModel.show)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear() {
                entryViewModel.addObserver()
            }
        }
    }
}

