//
//  GroupRepository.swift
//  ShootingApp
//
//  Created by soham gupta on 6/7/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class GroupRepository: ObservableObject {
    private let path: String = "groups"
    
    private let store = Firestore.firestore()
    
    func add(_ group: Group) {
        do {
            _ = try store.collection(path).addDocument(data: ["name": group.name, "creator": Auth.auth().currentUser?.uid ?? "Coach", "coaches": [Auth.auth().currentUser?.uid]])
        } catch {
          fatalError("Unable to add group: \(error.localizedDescription).")
        }
    }
    
    func get() -> [Group] {
        let groups : [Group] = []
        //gets the groups from the database
        return groups
    }
    
}

