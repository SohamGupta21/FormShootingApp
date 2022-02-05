//
//  TeamDetailView.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI

struct TeamDetailView: View {
    @Binding var team : Team
    @State private var data: Team.Data = Team.Data()
    @State private var isPresented = false
    var body: some View {
        List {
            Section(header: Text("\(team.name) Info")) {
                HStack {
                    Label("Coach", systemImage: "person.fill")
                    Spacer()
                    Text("\(team.coach)")
                }
                HStack {
                    Label("Color", systemImage: "paintpalette")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(team.color)
                }
                .accessibilityElement(children: .ignore)
            }
            
            Section(header: Text("Players")) {
                ForEach(team.players, id: \.self) { player in
                    Label(player, systemImage: "person")
                        .accessibilityLabel(Text("Person"))
                        .accessibilityValue(Text(player))
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            data = team.data
        })
        .navigationTitle("Details")
        .fullScreenCover(isPresented: $isPresented) {
            NavigationView {
                TeamEditView(teamData: $data)
                    .navigationTitle(team.name)
                    .navigationBarItems(leading: Button("Cancel") {
                        isPresented = false
                    }, trailing: Button("Done") {
                        isPresented = false
                    })
            }
        }

    }
}

//struct TeamDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamDetailView()
//    }
//}
