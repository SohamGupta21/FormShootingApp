//
//  DatabaseManager.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/15/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class DatabaseManager : ObservableObject {
    static let shared = DatabaseManager()
    let db = Firestore.firestore()
    var signedInUser = Auth.auth().currentUser?.uid
    
    func getTeams() {
        var teams : [String] = []
        var teamObjects : [Team] = []
        
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                for team in dataDescription["teams"] as! [String] {
                    teams.append(team)
                }
                // this doesn't load immediately since it is a database call
                print("AYOOOO")
                print(teams)
                for t in teams {
                    self.getTeamObject(uid: t, completion: { team -> Void in teamObjects.append(team)})
                }
                if teamObjects.count > 0 {
                    print(teamObjects[0])
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func getTeamObject(uid: String, completion: @escaping (Team) -> () ) {
        let db = Firestore.firestore()
        
        let docRef = db.collection("teams").document(uid)
        var answer : Team = Team.data[0]
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                answer = Team(teamID: uid, name: dataDescription["name"] as! String, membersNames: dataDescription["players"] as! [String], coachName: dataDescription["coach"] as! String)
                print(answer.name)
                print("1")
                completion(answer)
            } else {
                print("Document does not exist")

            }
        }
    }

    private init() { }
}
