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
        do {
            _ = try store.collection(path).document(Auth.auth().currentUser?.uid ?? "User").setData(["id": Auth.auth().currentUser?.uid])
        } catch {
          fatalError("Unable to add group: \(error.localizedDescription).")
        }
    }
}
