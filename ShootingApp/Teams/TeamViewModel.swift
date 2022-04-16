//
//  TeamViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 11/27/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TeamViewModel : ObservableObject{
    var teams : [String] = []
    
    init(){
        loadTeamsFromDatabase()
    }
    
    func loadTeamsFromDatabase() {
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                for team in dataDescription["teams"] as! [String] {
                    self.teams.append(team)
                }
                // this doesn't load immediately since it is a database call
                print("we are heressssss")
                print(self.teams)
            } else {
                print("Document does not exist")
            }
        }
    }
}
