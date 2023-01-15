//
//  ShootingAppApp.swift
//  ShootingApp
//
//  Created by soham gupta on 4/20/21.
//

import SwiftUI
import Firebase
@main
struct ShootingAppApp: App {
        
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            EntryView()
                .preferredColorScheme(.dark)
        }
        

    }
}
