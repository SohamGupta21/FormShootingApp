//
//  UserRepository.swift
//  ShootingApp
//
//  Created by soham gupta on 6/9/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserRepository: ObservableObject {
    private let path: String = "users"
    
    private let store = Firestore.firestore()
    
    func add(_ user: User) {
        //add a new user to the user database
        do {
            _ = try store.collection(path).document(Auth.auth().currentUser?.uid ?? "User").setData(["name": user.name, "groups": []])
        } catch {
          fatalError("Unable to add user: \(error.localizedDescription).")
        }
    }
    
    func addGroup(user: User, group: Group){
        //TODO change this to a group id
        do {
            _ = try store.collection(path).document(Auth.auth().currentUser?.uid ?? "User").updateData([
                "groups": FieldValue.arrayUnion([group.name])
            ])
        } catch {
          fatalError("Unable to add group: \(error.localizedDescription).")
        }
    }
}
