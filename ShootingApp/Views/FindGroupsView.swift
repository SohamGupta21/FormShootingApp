//
//  FindGroupsView.swift
//  ShootingApp
//
//  Created by soham gupta on 6/19/21.
//

import SwiftUI

struct FindGroupsView: View {
    @State private var userTyped: String = ""
    @ObservedObject var groupViewModel: GroupViewModel
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Image(systemName: "magnifyingglass")
                    TextField("Search", text: $userTyped, onCommit: {
                        findGroupsByKeyWord()
                    })
                }
                .padding()
                List{
                    // Fill this with the groups that will come back from the search
                }
                Spacer()
            }
            .navigationTitle("Find Groups")
        }
        
    }
    func findGroupsByKeyWord(){
        // searchs through the database: two options:
        // 1: have a file with the group names that it looks through
        // 2: keeps the id of each group as it's name
    }
}

struct FindGroupsView_Previews: PreviewProvider {
    static var previews: some View {
        FindGroupsView(groupViewModel: GroupViewModel())
    }
}
