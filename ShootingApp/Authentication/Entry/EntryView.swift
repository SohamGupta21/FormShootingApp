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
        NavigationView{
            if entryViewModel.status{
                HomeScreen()
                    .onAppear(perform: setBackgroundColor)
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
}

func setBackgroundColor() -> Void {
    UINavigationBar.appearance().backgroundColor = UIColor.black
}


struct EntryView_Previews : PreviewProvider {
    static var previews: some View {
        EntryView()
    }
}
