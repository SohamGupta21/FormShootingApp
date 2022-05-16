//
//  TeamDetailView.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI
import FirebaseFirestore

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
            
            Section(header: Text("Leaderboard")) {
                ForEach(0..<createLeaderboard(players : team.players).count) { ind in
                    Text(createLeaderboard(players : team.players)[ind])
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarItems(trailing: Button("Edit") {
            isPresented = true
            //data = team.data
        })
        .navigationTitle(team.name)
//        .fullScreenCover(isPresented: $isPresented) {
//            NavigationView {
////                TeamEditView(teamData: $data)
////                    .navigationTitle(team.name)
////                    .navigationBarItems(leading: Button("Cancel") {
////                        isPresented = false
////                    }, trailing: Button("Done") {
////                        isPresented = false
////                    })
//            }
//        }

    }
}

func createLeaderboard(players : [User]) -> [String] {
    var leaderboard = [String:Int]()
    // for each player
    for player in players {
        var shotTotal = calculateShotTotal(userId: player.id)
        leaderboard[player.username] = shotTotal
    }
    
    let rankedLeaderboard = leaderboard.sorted { (first, second) -> Bool in
        return first.value > second.value
    }
    
    var words_array = [String]()
    for (name, shotTotal) in rankedLeaderboard {
        words_array.append("\(name) - \(shotTotal)")
    }
    
    return words_array
}

func calculateShotTotal(userId : String) -> Int {
    
    var total = 0
    
    let docRef = Firestore.firestore().collection("users").document(userId)
    
    docRef.getDocument { (document, error) in
        if let document = document, document.exists {
            let dataDescription = document.data()!
            
            var workoutLog = dataDescription["workout_log"] as! [[String : String]]
            
            for workout in workoutLog {
                total = total + (Int(workout["shots_taken"] as! String) ?? 0)
            }
        } else {
            print("Document does not exist")
        }
    }
    
    return total
}

//struct TeamDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamDetailView()
//    }
//}
