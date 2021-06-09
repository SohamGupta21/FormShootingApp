//
//  EditGroupView.swift
//  ShootingApp
//
//  Created by soham gupta on 6/1/21.
//

import SwiftUI

struct EditGroupView: View {
    @Binding var groupData: Group.Data
    var body: some View {
        List {
            Section(header: Text("Group Info")) {
                TextField("Name", text: $groupData.name)
                TextField("Coach", text: $groupData.coach)
                ColorPicker("Color", selection: $groupData.color)
            }
            Section(header:Text("Workouts")){
                ForEach(groupData.workouts, id:\.self){ workout in
                    Text(workout)
                }
                .onDelete(perform: { indexSet in
                    groupData.workouts.remove(atOffsets: indexSet)
                    //change this when database functionality is added
                })
            }
            Section(header:Text("Players")){
                ForEach(groupData.players, id:\.self){ player in
                    Label(player, systemImage: "person")
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct EditGroupView_Previews: PreviewProvider {
    static var previews: some View {
        EditGroupView(groupData: .constant(Group.data[0].data))
    }
}
