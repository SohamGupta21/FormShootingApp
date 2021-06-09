//
//  GroupViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 6/7/21.
//

import Foundation
import FirebaseFirestore
import Combine

class GroupViewModel: ObservableObject {
    @Published var groupRepository = GroupRepository()
    func add(_ group : Group){
        groupRepository.add(group)
    }
}
