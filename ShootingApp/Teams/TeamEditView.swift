//
//  TeamEditView.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI

struct TeamEditView: View {
    @Binding var teamData : Team.Data
    @State var newPlayer = ""
    var body: some View {
        List {
               Section(header: Text("Team Info")) {
                   TextField("Name", text: $teamData.name)
                   ColorPicker("Color", selection: $teamData.color)
               }
//               Section(header: Text("Players")) {
//                   ForEach(teamData.players, id: \.self) { player in
//                       Text(player)
//                   }
//                   .onDelete { indices in
//                       teamData.players.remove(atOffsets: indices)
//                   }
//                   HStack {
//                       TextField("New Player", text: $newPlayer)
//                       Button(action: {
//                           withAnimation {
//                               teamData.membersNames.append(newPlayer)
//                               newPlayer = ""
//                           }
//                       }) {
//                           Image(systemName: "plus.circle.fill")
//                       }
//                       .disabled(newPlayer.isEmpty)
//                   }
//               }
           }
           .listStyle(InsetGroupedListStyle())
    }
}

//struct TeamEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamEditView()
//    }
//}
