//
//  SignUp.swift
//  ShootingApp
//
//  Created by soham gupta on 10/4/21.
//

import SwiftUI

struct SignUp: View {
    
    @Binding var show: Bool
    
    @StateObject var signUpViewModel = SignUpViewModel()
    
    var colors = Colors()
    
    var body: some View {

            ZStack(alignment: .topLeading){
                GeometryReader { geo in
                    // Photo by Mira Kireeva on Unsplash
                    Image("girl-shooting")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width)
                        .edgesIgnoringSafeArea(.all)
                }
                GeometryReader{geometry in
                    VStack {
                        Text("Register")
                            .font(.title)
                            .foregroundColor(colors.whiteColor)
                            .cornerRadius(50)
                        TextField("Email", text: $signUpViewModel.email)
                            .autocapitalization(.none)
                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                            )
                            .padding(.top, 25)
                            .opacity(0.85)
                            .foregroundColor(colors.greyColor)
                        HStack{
                            VStack{
                                if signUpViewModel.visible{
                                    TextField("Password", text:$signUpViewModel.pass)
                                        .autocapitalization(.none)
                                        .foregroundColor(colors.greyColor)
                                } else {
                                    SecureField("Password", text: $signUpViewModel.pass)
                                        .autocapitalization(.none)
                                        .foregroundColor(colors.greyColor)
                                }
                            }
                            Button(action: {
                                signUpViewModel.visible.toggle()
                            }) {
                                Image(systemName: signUpViewModel.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(signUpViewModel.color)
                            }
                        }
                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                        )
                        .padding(.top, 25)
                        .opacity(0.85)
                            
                        HStack{
                            VStack{
                                if signUpViewModel.revisible{
                                    TextField("Re-enter", text:$signUpViewModel.repass)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Re-enter", text: $signUpViewModel.repass)
                                        .autocapitalization(.none)
                                }
                            }
                            Button(action: {
                                signUpViewModel.revisible.toggle()
                            }) {
                                Image(systemName: signUpViewModel.revisible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(signUpViewModel.color)
                            }
                        }
                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                        )
                        .padding(.top, 25)
                        .opacity(0.85)
                
                        
                        HStack{
                            VStack{
                                TextField("Username", text: $signUpViewModel.username)
                                    .autocapitalization(.none)
                                    .padding()
//                                    .background(
//                                        RoundedRectangle(cornerRadius:50).fill(colors.whiteColor)
//                                    )
                                    .padding(.top, 25)
                                    .opacity(0.85)
                            }
                        }
                        
                        Button(action: {
                            signUpViewModel.register()
                        }) {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(colors.orangeColor)
                        .cornerRadius(50)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                    .frame(height:geometry.size.height/1.5)
                            
                }
                
//                Button(action:{
//                    self.show.toggle()
//                }){
//                    Image(systemName: "chevron.left")
//                        .font(.title)
//                        .foregroundColor(Color.blue)
//                }
//                .padding()
            }
            
            if signUpViewModel.alert{
                ErrorView(alert: $signUpViewModel.alert, error: $signUpViewModel.error)
            }
        }
        
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp(show:.constant(false))
    }
}
