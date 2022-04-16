//
//  WorkoutInformationTag.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/4/22.
//

import SwiftUI

struct WorkoutInformationTag : View {
    
    var image = "ball_court"
    var title = "Layup King"
    var length = "50 shots"
    
    var body : some View {
        NavigationLink(destination: Text("destination")) {
            VStack(alignment: .leading, spacing: 16.0) {
                Image(image)
                    .resizable()
                    .frame(width:150, height:150)
                cardText.padding(.horizontal, 8)
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 24.0))
            .shadow(radius:8)
        }
    }
    
    var cardText: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
            HStack(spacing: 4.0) {
                Image(systemName: "clock.arrow.circlepath")
                Text(length)
            }.foregroundColor(.gray)
                .padding(.bottom, 16)
        }
    }
}


struct WorkoutInformationTag_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutInformationTag()
    }
}

