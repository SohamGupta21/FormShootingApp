//
//  TeamsModel.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import Foundation
import SwiftUI


struct Team : Identifiable{
    // the team id in the database
    var id : String
    
    var name : String
    
    var description : String
    
    // all of these will be the same size, it is just easier to split them up
    
    var players : [User] = []
    
    // the information for the coach
    var coach : User
    
    init(teamID : String, name : String, desc : String, players : [User], coach : User){
        
        self.id = teamID
        
        self.name = name
        
        self.description = desc
        
        self.players = players
        
        self.coach = coach
        
    }
    
    init(){
        self.id = ""
        
        self.name = ""
        
        self.description = ""
        
        self.players = []
        
        self.coach = User(userID: "", name: "")
    }
}

struct User : Identifiable{
    // the team id in the database
    var id : String
    
    var username : String
    
    
    init(userID : String, name : String){
        
        self.id = userID
        
        self.username = name
        
    }
}

