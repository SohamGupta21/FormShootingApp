//
//  HomeScreen.swift
//  ShootingApp
//
//  Created by soham gupta on 5/29/21.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct HomeScreen: View {
    @Binding var groups: [Group]
    @State private var isPresented = false
    @State private var newGroupData = Group.Data()
    @ObservedObject var groupViewModel:GroupViewModel
    let db = Firestore.firestore()
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Text("Groups")
                    Spacer()
                    Button(action: {
                        isPresented = true
                    }) {
                        Image(systemName: "plus")
                    }
                }.padding()
                List {
                    ForEach(groups, id: \.name) { group in
                        NavigationLink(destination: GroupDetailView(group:binding(for:group))){
                            GroupView(group: group)
                        }.listRowBackground(group.color)
                        
                    }
                }.padding()
            }
        }
        .navigationTitle("Analyze")
        .navigationBarItems(trailing:
            NavigationLink(
            destination: UserInfo(),
            label: {
                Button(action: {
                    print("Log out")
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }) {
                    Text("Log out")
                }
                .padding(.top, 25)
                Spacer()
                Image(systemName: "gearshape.fill")
            }
        ))
        .sheet(isPresented: $isPresented, content: {
            NavigationView{
                EditGroupView(groupData: $newGroupData)
                    .navigationBarItems(leading: Button("Dismiss") {
                            isPresented = false
                        }, trailing: Button("Add") {
                            let newGroup = Group(name: newGroupData.name, coach: newGroupData.coach, players:newGroupData.players, workouts: newGroupData.workouts , color:newGroupData.color)
                            groups.append(newGroup)
                            groupViewModel.add(newGroup)
                            isPresented = false
                        })
            }
        })
    }
    private func binding(for group: Group) -> Binding<Group> {
        guard let groupIndex = groups.firstIndex(where: { $0.name == group.name }) else {
            fatalError("Can't find scrum in array")
        }
        return $groups[groupIndex]
    }
    
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            HomeScreen(groups: .constant(Group.data),groupViewModel: GroupViewModel())
        }
    }
}
