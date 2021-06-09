//
//  GroupView.swift
//  ShootingApp
//
//  Created by soham gupta on 5/29/21.
//

import SwiftUI

struct GroupView: View {
    let group: Group
    var body: some View {
        VStack(alignment: .leading){
            Text(group.name)
                .font(.headline)
            Spacer()
            HStack {
                Label("\(group.players.count)", systemImage: "person.3")
                Spacer()
                Label("\(group.workouts.count)", systemImage: "bolt.horizontal.circle.fill")
                    .padding(.trailing, 20)
            }
            .font(.caption)
        }
        .padding()
        .foregroundColor(Color.black)
    }
}

struct GroupView_Previews: PreviewProvider {
    static var group = Group.data[0]
    static var previews: some View {
        NavigationView{
            GroupView(group: group)
                        .background(group.color)
                        .previewLayout(.fixed(width: 400, height: 600))
        }
        
    }
}
