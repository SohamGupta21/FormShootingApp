//
//  TeamEditView.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI

struct TeamEditView: View {
    @State var newPlayer = ""
    var team : Team
    var body: some View {
        
        Text("Jello World")
//        List {
//               Section(header: Text("Team Info")) {
//                   TextField("Name", text: team.name)
//               }
//               Section(header: Text("Players")) {
//                   ForEach(team.players, id: \.self) { player in
//                       Text(player.username)
//                   }
//                   .onDelete { indices in
//                       team.players.remove(atOffsets: indices)
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
//           }
//           .listStyle(InsetGroupedListStyle())
    }
}

//struct TeamEditView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamEditView()
//    }
//}
