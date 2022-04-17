//
//  TeamJoinView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/16/22.
//

import SwiftUI

struct TeamJoinView: View {
    @State var code : String = ""
    @ObservedObject var teamViewModel : TeamViewModel
    var body: some View {
        VStack {
            TextField("Team Code", text: $code)
            Button(action: {
                teamViewModel.joinNewTeam(code: code)
            }, label: {
                Text("Join Team")
            })
        }.padding()
    }
}

//struct TeamJoinView_Previews: PreviewProvider {
//    static var previews: some View {
//        TeamJoinView()
//    }
//}
