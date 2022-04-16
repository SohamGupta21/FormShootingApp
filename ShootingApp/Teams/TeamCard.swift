//
//  TeamCard.swift
//  ShootingApp
//
//  Created by soham gupta on 11/26/21.
//

import SwiftUI

struct TeamCard: View {
    var colors = Colors()
    var team : Team
    var body: some View{
        VStack{
            Text(team.name)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding()
        .cornerRadius(15)
        
    }
}

struct TeamCard_Previews: PreviewProvider {
    static var team = Team.data[0]
    static var previews: some View {
        ProductCard(image:"team_logo", title: "Tigers", type: "We are the Tonetown high school Tigers! Rawr!!", price: 10)
    }
}


struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .cornerRadius(20)
            .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 0)
    }
    
}

struct ProductCard: View {
    
    var image: String
    var title: String
    var type: String
    var price: Double
    
    var body: some View {
        HStack(alignment: .center) {
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text(type)
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(.gray)
                HStack {
                    Text(String.init(format: "%0.0f", price) + " members")
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
