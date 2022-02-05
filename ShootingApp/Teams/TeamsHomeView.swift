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
    @State var team1 = Team.data[0]
    @StateObject var teamViewModel : TeamViewModel = TeamViewModel()
    // queries the database in order to get all of the person's teams
    var body: some View {
        VStack {
            Heading("Teams You Coach:")
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(0..<10) {_ in
                        NavigationLink(destination: TeamDetailView(team: $team1)){
                            TeamCard(team: team1)
                        }
                    }
                }
            }
            Heading("Teams You Play For:")
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(0..<10) {_ in
                        NavigationLink(destination: TeamDetailView(team: $team1)){
                            TeamCard(team: team1)
                        }
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
