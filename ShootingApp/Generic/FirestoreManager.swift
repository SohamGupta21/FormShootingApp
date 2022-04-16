//
//  FirestoreManager.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/16/22.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreManager: ObservableObject {
    
    
    @Published var team : String = ""
    
    @Published var teams : [Team] = []
    
    init(){
        fetchTeam()
        fillTeams()
    }
    
    func fetchTeam() {
        let db = Firestore.firestore()

        let docRef = db.collection("teams").document("ckcal19WlNpFQPUqIroc")

        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    print("data", data)
                    self.team = data["name"] as? String ?? ""
                }
            }

        }
    }
    
    func fillTeams() {
        // get the list of teams that the current user is a part of

        let db = Firestore.firestore()
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                for team in dataDescription["teams"] as! [String] {
                    // make a database call for information about this team
                    self.singleTeamDatabaseCall(uid: team)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func singleTeamDatabaseCall(uid: String){
        let db = Firestore.firestore()
        
        let docRef = db.collection("teams").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                self.teams.append(Team(teamID: uid, name: dataDescription["name"] as! String, membersNames: dataDescription["players"] as! [String], coachName: dataDescription["coach"] as! String))
            } else {
                print("Document does not exist")

            }
        }
    }
}
