//
//  QuickImprovementStartScreen.swift
//  ShootingApp
//
//  Created by soham gupta on 10/7/21.
//

import SwiftUI

struct QuickImprovementStartScreen: View {
        
    var body: some View {
        ZStack{
            VStack{
                NavigationButton(destContent: {Text("Hello")}, text: "Get Started")
            }
        }
        
        
    }
}

struct QuickImprovementStartScreen_Previews: PreviewProvider {
    static var previews: some View {
        QuickImprovementStartScreen()
    }
}
