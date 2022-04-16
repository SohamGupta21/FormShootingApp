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
    
    @StateObject var firestoreManager = FirestoreManager()
    
    init(){
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            EntryView()
                .environmentObject(firestoreManager)
        }
    }
}
