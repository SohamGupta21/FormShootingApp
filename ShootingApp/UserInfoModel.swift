//
//  UserInfoModel.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/16/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserInfoModel{
    var username : String = ""
    
    static let shared = UserInfoModel()
    
    let db = Firestore.firestore()
    
    private init(){
        print("User Info Model is being initialized")
        loadUserName()
    }
    
    func loadUserName() {
        // get the list of teams that the current user is a part of

        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                self.username = dataDescription["username"] as! String
            } else {
                print("Document does not exist")
            }
        }
    }
}
