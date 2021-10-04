//
//  ErrorView.swift
//  ShootingApp
//
//  Created by soham gupta on 8/6/21.
//

import SwiftUI

struct ErrorView : View {
    @Binding var alert : Bool
    @Binding var error : String
    var colors = Colors()
    var body: some View{
        GeometryReader{geometry in
            VStack{
                HStack{
                    Spacer()
                    Text(self.error == "RESET" ? "Message" : "Error")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colors.orangeColor)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent" : self.error)
                    .foregroundColor(colors.orangeColor)
                    .padding(.top)
                    .padding(.horizontal, 25)
                
                Button(action: {
                    self.alert.toggle()
                }){
                    Text(self.error == "RESET" ? "Ok" : "Cancel")
                        .foregroundColor(colors.whiteColor)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(colors.orangeColor)
                .cornerRadius(10)
                .padding(.top, 25)
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width-70)
            .background(colors.whiteColor)
            .cornerRadius(15)
            .frame(width:geometry.size.width)
        }
        .background(Color.black.opacity(0.35).edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
    }
}
struct ErrorView_Previews : PreviewProvider {
    static var previews: some View {
        ErrorView(alert: .constant(false), error:.constant("Please fill contents properly"))
    }
}

