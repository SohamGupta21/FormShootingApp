//
//  UserViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 6/9/21.
//

import Foundation
import FirebaseFirestore
import Combine

class UserViewModel: ObservableObject {
    @Published var userRepository = UserRepository()
    @Published var mainUser = User(name: "",id: "",groups: [])
    
    func createUser(_ user: User){
        mainUser.update(n: user.name, i: user.id)
    }

    func add(_ user : User){
        // creates a new user object that will be used throughout the program
        //updates the database with a new user
        userRepository.add(user)
    }
    
    func addGroup(_ group : Group){
        mainUser.groups.append(group)
        userRepository.addGroup(user: mainUser, group: group)
    }
    
}
