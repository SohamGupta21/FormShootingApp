//
//  BasicInformationRepository.swift
//  ShootingApp
//
//  Created by soham gupta on 6/19/21.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import Combine

class BasicInformationRepository: ObservableObject {
    private let path: String = "basicInformation"
    private let doc = "Groups"
    private let store = Firestore.firestore()
    
    func add(name: String, id: String) {
        print("supposed to add")
//        do {
//            _ = try store.collection(path).document(doc).updateData([
//                "names" : FieldValue.arrayUnion({name:id})
//            ])
//
//        } catch {
//          fatalError("Unable to add group: \(error.localizedDescription).")
//        }
    }
    
    func get() -> [Group] {
        let groups : [Group] = []
        //gets the groups from the database
        return groups
    }
    
}
