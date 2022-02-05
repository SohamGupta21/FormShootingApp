//
//  TeamCard.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI

struct TeamCard: View {
    var colors = Colors()
    var team : Team
    var body: some View{
        VStack{
            Text(team.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .background(team.color)
        .cornerRadius(15)
        
    }
}

struct TeamCard_Previews: PreviewProvider {
    static var team = Team.data[0]
    static var previews: some View {
        TeamCard(team : team)
    }
}
