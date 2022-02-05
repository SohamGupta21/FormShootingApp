//
//  WorkoutStartPopUpView.swift
//  ShootingApp
//
//  Created by soham gupta on 10/20/21.
//

import SwiftUI

struct WorkoutStartPopUpView: View {
    @Binding var alert : Bool
    var colors = Colors()
    var messages = "Start your workout. Your shots will automatically get counted and your form analyzed. Let's get it!"
    var body: some View{
            VStack{
                HStack{
                    Spacer()
                    Text("Start Workout")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colors.orangeColor)
                    
                    Spacer()
                }
                
                Text(self.messages)
                    .foregroundColor(colors.orangeColor)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                }){
                    Text("Begin")
                        .foregroundColor(colors.whiteColor)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(colors.orangeColor)
                .cornerRadius(10)
                .padding(.top, 25)
                .accessibilityIdentifier("Begin")
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width-70)
            .background(colors.greyColor)
            .cornerRadius(15)
    }
}

struct WorkoutStartPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutStartPopUpView(alert: .constant(false))
    }
}
