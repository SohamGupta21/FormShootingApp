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
    func add(_ user : User){
        userRepository.add(user)
    }
}
