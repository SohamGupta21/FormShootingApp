//
//  TeamViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 11/27/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class TeamViewModel : ObservableObject{
    @Published var teams : [Team] = []
    
    var userInfoModel : UserInfoModel = UserInfoModel.shared
    
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
                
                let code = dataDescription["code"] as! String
                
                if playerIDs.count > 0{
                    for (index, _) in playerIDs.enumerated() {
                        print(teamName)
                        print(index)
                        players.append(User(userID: playerIDs[index], name: playerNames[index]))
                    }
                }
                

                self.teams.append(Team(teamID: teamID, name: teamName, desc: teamDescription, players: players, coach: coach, code : code))
            } else {
                print("Document does not exist")

            }
        }
    }
    
    func createNewTeam(name: String, description: String, loggedInUserName : String){
        
        var proposedCode = randomString(length: 6)
        
        var codes = db.collection("teams").whereField("code", isEqualTo: proposedCode)
        
        while codes.accessibilityElementCount() != 0 {
            proposedCode = randomString(length: 6)
            codes = db.collection("teams").whereField("code", isEqualTo: proposedCode)
        }
        
        
        let docData: [String: Any] = [
            "name": name,
            "description": description,
            "coachID": Auth.auth().currentUser?.uid,
            "coachName": loggedInUserName,
            "code" : proposedCode,
            "playerIDs": [String](),
            "playerNames": [String](),
            "workouts" : [String]()
        ]
        
        let newDocId = UUID().uuidString
        
        let docRef = db.collection("teams").document(newDocId)
        
        self.addNewTeamToUser(teamID: newDocId)

        docRef.setData(docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
        var teamToAdd = Team(teamID: newDocId, name: name, desc: description, players: [], coach: User(userID: Auth.auth().currentUser?.uid ?? "", name: loggedInUserName), code: proposedCode)
        
        teams.append(teamToAdd)
    }
    
    func addNewTeamToUser(teamID : String) {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.updateData([
            "teams": FieldValue.arrayUnion([teamID])
        ])
    }
    
    func addNewUserToTeam(teamID : String){
        let docRef = db.collection("teams").document(teamID)
        
        docRef.updateData([
            "playerIDs": FieldValue.arrayUnion([Auth.auth().currentUser?.uid ?? ""])
        ])
        
        let userDocRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")

        userDocRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                
                let userName = dataDescription["username"] as! String
                
                docRef.updateData([
                    "playerNames": FieldValue.arrayUnion([self.userInfoModel.username])
                ])
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    func joinNewTeam(code : String){
        db.collection("teams").whereField("code", isEqualTo: code)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        // add this user to the teams document
                        self.addNewUserToTeam(teamID: document.documentID)
                        // add this team to the user's persoal document
                        self.addNewTeamToUser(teamID: document.documentID)
                        // update the teams array so that the user can see this change in the UI
                        self.singleTeamDatabaseCall(uid: document.documentID)
                    }
                }
        }
    }
    
    func randomString(length: Int) -> String {
      let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
      return String((0..<length).map{ _ in letters.randomElement()! })
    }
   
}
