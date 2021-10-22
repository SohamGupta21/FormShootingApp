//
//  Heading.swift
//  ShootingApp
//
//  Created by soham gupta on 10/7/21.
//

import SwiftUI

struct Heading: View {
    
    var colors = Colors()
    
    var text : String
    
    init(_ text : String){
        self.text = text
    }
    
    var body: some View {
        HStack{
            Text(self.text)
                .font(.title2)
                .foregroundColor(colors.whiteColor)
                .cornerRadius(50)
            Spacer()
        }
        .padding()
    }
}

struct Heading_Previews: PreviewProvider {
    static var previews: some View {
        Heading("Yoooo")
    }
}
