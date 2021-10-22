//
//  NavigationButton.swift
//  ShootingApp
//
//  Created by soham gupta on 10/7/21.
//

import SwiftUI

struct NavigationButton<Content: View>: View {
    var dest : Content
    
    var text : String
    
    var colors = Colors()
    
    init(@ViewBuilder destContent: () -> Content, text:String){
        self.dest = destContent()
        self.text = text
    }
    
    var body: some View {
        NavigationLink(destination: self.dest, label:{
            Text(self.text)
                .foregroundColor(.white)
                .padding(.vertical)
                .frame(width: UIScreen.main.bounds.width - 50)
        })
        .background(colors.orangeColor)
        .cornerRadius(50)
        .padding(.top, 25)
    }
}

struct NavigationButton_Previews: PreviewProvider {
    static var previews: some View {
        NavigationButton(destContent:{WorkoutEntryView()}, text:"Soham")
    }
}
