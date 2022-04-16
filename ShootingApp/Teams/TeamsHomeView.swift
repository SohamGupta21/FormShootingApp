//
//  TeamsHomeView.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TeamsHomeView: View {
    //@State var team1 = Team.data[0]
    @StateObject var teamViewModel : TeamViewModel = TeamViewModel()
    @EnvironmentObject var firestoreManager : FirestoreManager
    // queries the database in order to get all of the person's teams
    var body: some View {
        VStack {
            Heading("Your Teams:")
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(firestoreManager.teams) {team in
                        ProductCard(image: "team_logo", title: team.name, type: team.id, price: Double(team.players.count))
                    }
                }
            }
            Spacer()
            Button(action: {
                // create a new team
            }){
                HStack{
                    Image(systemName: "plus")
                    Text("Create New Team")
                }
            }
            Spacer()
            Button(action: {
                // join a new team
            }){
                HStack{
                    Image(systemName: "arrow.up.circle")
                    Text("Join New Team")
                }
            }
            Spacer()
        }
    }
}

struct TeamsHomeView_Previews: PreviewProvider {
    static var previews: some View {
        TeamsHomeView()
    }
}
