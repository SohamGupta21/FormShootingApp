//
//  StatisticsModel.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/19/22.
//

import Foundation
import SwiftUI

// sample data

struct Daily : Identifiable {
    var id : Int
    var day : String
    var workout_In_Min : Int
}


struct Stats : Identifiable {
    var id : Int
    var title : String
    var currentData : CGFloat
    var goal : CGFloat
    var color : Color
}

