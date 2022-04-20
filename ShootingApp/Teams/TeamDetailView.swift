//
//  TeamDetailView.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI

struct TeamDetailView: View {
    var team : Team
    @State private var isPresented = false
    
    init(team : Team) {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.red]
        
        self.team = team
    }
    var body: some View {
        List {
            Section(header: Text("\(team.name) Info")) {
                HStack {
                    Label("Coach", systemImage: "person.fill")
                    Spacer()
                    Text("\(team.coach.username)")
                }
                HStack {
                    Label("Code", systemImage: "person.fill")
                    Spacer()
                    Text("\(team.code)")
                }
                NavigationLink(destination: {
                    Chat(chatViewModel: ChatViewModel(teamID: team.id))
                }, label: {
                    Text("Chat")
                })
            }
            
            
            Section(header: Text("Description")) {
                Text(team.description)
            }
            
            Section(header: Text("Players")) {
                ForEach(0..<team.players.count) { ind in
                    Label(team.players[ind].username, systemImage: "person")
                        .accessibilityLabel(Text("Person"))
                        //.accessibilityValue(Text(player))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            //data = team.data
        })
        .navigationTitle(team.name)
        .navigationBarColor(backgroundColor: .orange, titleColor: .black)
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
//                TeamEditView(teamData: $data)
//                    .navigationTitle(team.name)
//                    .navigationBarItems(leading: Button("Cancel") {
//                        isPresented = false
//                    }, trailing: Button("Done") {
//                        isPresented = false
//                    })
            }
        }

    }
}

//struct TeamDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamDetailView()
//    }
//}
