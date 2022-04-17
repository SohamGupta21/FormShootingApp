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
    @State var updater : Bool = false
    // queries the database in order to get all of the person's teams
    var body: some View {
        VStack {
            Text("My Teams:")
                .font(.headline)
                .padding()
            ScrollView(.vertical) {
                VStack(spacing: 20) {
                    ForEach(teamViewModel.teams) {team in
                        NavigationLink(
                        destination: {
                            TeamDetailView(team:team)
                        },label: {
                            TeamCard(image: "team_logo", name: team.name, description: team.description, num_players: team.players.count)
                        })
                    }
                }
            }
            Spacer()
            NavigationLink (destination: {
                TeamCreateView(teamViewModel: teamViewModel)
            }, label: {
                HStack{
                    Image(systemName: "plus")
                    Text("Create New Team")
                }
            })
            Spacer()
            
            NavigationLink (destination: {
                TeamJoinView(teamViewModel: teamViewModel)
            }, label: {
                HStack{
                    Image(systemName: "arrow.up.circle")
                    Text("Join New Team")
                }
            })
            Spacer()
        }
    }
}

//struct TeamsHomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamsHomeView()
//    }
//}
