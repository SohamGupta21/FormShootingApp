//
//  Group.swift
//  ShootingApp
//
//  Created by soham gupta on 5/29/21.
//

import Foundation
import SwiftUI

struct Group{
    var name: String
    var coach: String
    var players: [String]
    var workouts: [String]
    var color: Color
}


extension Group{
    static var data: [Group] {
        [
            Group(name: "Conant Basketball", coach: "Matt Walsh", players: ["Soham", "Varun", "Aarav"], workouts: ["Sprints", "Ladders"], color: Color.blue),
            Group(name: "Chicago Bulls", coach: "Billy Donovan", players: ["Zach Lavine", "Coby White", "Nikola Vucevic"], workouts: ["3 pt shooting", "Dunk Contest"], color: Color.red)

        ]
    }
}

extension Group{
    struct Data{
        var name: String = ""
        var coach: String = ""
        var players:[String] = []
        var workouts: [String] = []
        var color: Color = Color.blue
    }
    var data: Data {
        return Data(name: name, coach: coach, players: players, workouts: workouts, color: color)
    }
    mutating func update(from data: Data) {
        name = data.name
        coach = data.coach
        players = data.players
        workouts = data.workouts
        color = data.color
    }
}
