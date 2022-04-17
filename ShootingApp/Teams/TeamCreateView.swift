//
//  TeamCreateView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/16/22.
//

import SwiftUI

struct TeamCreateView: View {
    @ObservedObject var teamViewModel : TeamViewModel
    @State var teamName = ""
    @State var teamDescription = ""
    var body: some View {
        List {
            Section(header: Text("Team Info")) {
                TextField("Name", text: $teamName)
                TextField("Description", text: $teamDescription)
            }
            
            Button(action: {
                teamViewModel.createNewTeam(name: teamName, description: teamDescription, loggedInUserName: UserInfoModel.shared.username)
            }, label: {
                Text("Submit")
            })
        }
        .listStyle(InsetGroupedListStyle())
    }
}

//struct TeamCreateView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamCreateView()
//    }
//}
