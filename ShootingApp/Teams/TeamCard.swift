//
//  TeamCard.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI


struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}

struct TeamCard: View {
    
    var image: String
    var name: String
    var description: String
    var num_players: Int
    
    var body: some View {
        HStack(alignment: .center) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text(description)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.gray)
                HStack {
                    Text("\(num_players) members")
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(red: 32/255, green: 36/255, blue: 38/255))
        .modifier(CardModifier())
        .padding(.all, 10)
    }
}

