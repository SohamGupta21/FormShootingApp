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
    @Published var teams : [Team] = []
    
    let db = Firestore.firestore()
    
    init(){
        loadTeamsFromDatabase()
    }
    
    func loadTeamsFromDatabase() {
        // get the list of teams that the current user is a part of

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
        
        let docRef = db.collection("teams").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                
                let teamID = uid
                let teamName = dataDescription["name"] as! String
                let teamDescription = dataDescription["description"] as! String
                
                let coach = User(userID: dataDescription["coachID"] as! String, name: dataDescription["coachName"] as! String)
                
                var players = [User]()
                
                let playerIDs = dataDescription["playerIDs"] as! [String]
                let playerNames = dataDescription["playerNames"] as! [String]
                
                for (index, _) in playerIDs.enumerated() {
                    players.append(User(userID: playerIDs[index], name: playerNames[index]))
                }
                

                self.teams.append(Team(teamID: teamID, name: teamName, desc: teamDescription, players: players, coach: coach))
            } else {
                print("Document does not exist")

            }
        }
    }
    
    func createNewTeam(name: String, description: String){
        let docData: [String: Any] = [
            "name": name,
            "description": description,
            "coachID": "",
            "coachName": "",
            "playerIDs": [String](),
            "playerNames": [String](),
            "workouts" : [String]()
        ]
        
        let docRef = db.collection("teams").document(UUID().uuidString)

        docRef.setData(docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
    }
}
