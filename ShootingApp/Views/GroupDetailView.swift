//
//  GroupDetailView.swift
//  ShootingApp
//
//  Created by soham gupta on 5/31/21.
//

import SwiftUI

struct GroupDetailView: View {
    
    @Binding var group: Group
    @State private var data: Group.Data = Group.Data()
    @State private var isPresented = false
    var body: some View {
        VStack{
            List {
                Section(header: Text("Group Info")) {
                    HStack{
                        Label("Coach", systemImage: "person.fill")
                        Spacer()
                        Text("\(group.coach)")
                    }
                    HStack{
                        Label("Color", systemImage: "paintpalette")
                        Spacer()
                        Image(systemName: "circle.fill")
                            .foregroundColor(group.color)
                    }
                }
                Section(header:Text("Workouts")){
                    ForEach(group.workouts, id:\.self){ workout in
                        Label(workout, systemImage: "bolt.circle.fill")
                    }
                }
                Section(header:Text("Players")){
                    ForEach(group.players, id:\.self){ player in
                        Label(player, systemImage: "person")
                    }
                }
            }
            .navigationTitle(group.name)
            .navigationBarItems(trailing: Button("Edit"){
                isPresented = true
                data = group.data
            })
            .listStyle(InsetGroupedListStyle())
            .fullScreenCover(isPresented: $isPresented){
                NavigationView{
                    EditGroupView(groupData: $data)
                        .navigationTitle(group.name)
                        .navigationBarItems(leading: Button("Cancel") {
                                isPresented = false
                            }, trailing: Button("Done") {
                                isPresented = false
                                group.update(from: data)
                            })
                }
            }
        }
       
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            GroupDetailView(group: .constant(Group.data[0]))
        }
    }
}
