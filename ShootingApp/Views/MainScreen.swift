//
//  MainScreen.swift
//  ShootingApp
//
//  Created by soham gupta on 4/20/21.
//

import SwiftUI
import FirebaseFirestore

struct MainScreen: View {
    var body: some View {
        VStack(alignment: .center, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Text("Welcome User")
                .font(.title)
                .fontWeight(.bold)
            Text("hi")
            ZStack(alignment: .top, content: {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/4)
            })
        })
    }
}

struct MainScreen_Previews: PreviewProvider {
    static var previews: some View {
        MainScreen()
    }
}
