//
//  TeamsModel.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import Foundation
import SwiftUI


struct Team {
    // the team id in the database
    var teamID : String
    
    var name : String
    var color : Color
    
    // all of these will be the same size, it is just easier to split them up
    var players : [String]
    
    // the information for the coach
    var coach : String
    
    init(teamID : String, name : String, color : Color, membersNames : [String], coachName : String){
        
        self.teamID = teamID
        
        self.name = name
        self.color = color
        
        self.players = membersNames
        
        self.coach = coachName
        
    }
}


extension Team {
    static var data : [Team] {
        [
            Team(teamID: "sdfdf", name: "Conant", color: .blue, membersNames: ["Soham", "Michael Jordan", "Steph Curry"], coachName: "Coach Walsh"),
            Team(teamID: "sdfdf", name: "Bulls", color: .red, membersNames: [], coachName: "Billy Donovan"),
            Team(teamID: "sdfdf", name: "Sierra Canyon", color: .blue, membersNames: ["Soham", "Michael Jordan", "Steph Curry"], coachName: "Coach Walsh"),
            Team(teamID: "sdfdf", name: "Warriors", color: .red, membersNames: [], coachName: "Billy Donovan")
        ]
    }
}

extension Team {
    struct Data {
        var name: String = ""
        var coach : String = ""
        var players: [String] = []
        var color: Color = .blue
    }

    var data: Data {
        return Data(name: name,coach : coach, players: players, color: color)
    }
}
