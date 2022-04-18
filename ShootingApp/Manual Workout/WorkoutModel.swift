//
//  WorkoutModel.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/17/22.
//

import Foundation
import SwiftUI


struct Workout : Identifiable{
    var id: String
    
    var name : String
    
    // the drills that are a part of the workout
    
    var drills : [Drill]
    
    
    init(id : String, name : String, drills : [Drill]){
        self.id = id
        self.name = name
        self.drills = drills
    }
    
    init() {
        self.id = UUID().uuidString
        self.name = ""
        self.drills = []
    }
}

struct Drill: Identifiable {
    
    var id : String = UUID().uuidString
    
    var name : String
    var amount : Int
    var madeBaskets : Int = 0
    
    init(name: String, amount : Int) {
        self.name = name
        self.amount = amount
    }
}
