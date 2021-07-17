//
//  Group.swift
//  ShootingApp
//
//  Created by soham gupta on 5/29/21.
//

import Foundation
import SwiftUI

struct User {
    
    //this object is used so that we can do one quick read at the beginning and it will help mininmize the calls to the firestore database
    
    var name: String = ""
    var id : String = ""
    var groups: [Group] = []
    
//    init(name: String, id: String, groups: [Group]){
//        self.name = name
//        self.id = id
//        self.groups = groups
//    }
    mutating func update(n: String, i: String){
        name = n
        id = i
    }
}

