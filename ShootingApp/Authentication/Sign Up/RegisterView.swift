//
//  RegisterView.swift
//  ShootingApp
//
//  Created by soham gupta on 10/3/21.
//

import SwiftUI

struct RegisterView: View {
    @Binding var show: Bool
    
    @StateObject var signUpViewModel = SignUpViewModel()
    var body: some View {
        ZStack{
            ZStack(alignment: .topLeading){
                GeometryReader{_ in
                    VStack {
                        Text("Log in to your account")
                        TextField("Email", text: $signUpViewModel.email)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius:4).stroke(signUpViewModel.email != "" ? Color("Color") : signUpViewModel.color, lineWidth: 2))
                            .padding(.top, 25)
                        HStack{
                            VStack{
                                if signUpViewModel.visible{
                                    TextField("Password", text:$signUpViewModel.pass)
                                        .autocapitalization(.none)
                                } else {
                                    SecureField("Password", text: $signUpViewModel.pass)
                                        .autocapitalization(.none)
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
                        .background(RoundedRectangle(cornerRadius:4).stroke(signUpViewModel.pass != "" ? Color("Color") : signUpViewModel.color, lineWidth: 2))
                        .padding(.top, 25)
                            
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
                        .background(RoundedRectangle(cornerRadius:4).stroke(signUpViewModel.pass != "" ? Color("Color") : signUpViewModel.color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        HStack{
                            VStack{
                                TextField("Username", text: $signUpViewModel.username)
                            }
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius:4).stroke(signUpViewModel.pass != "" ? Color("Color") : signUpViewModel.color, lineWidth: 2))
                        .padding(.top, 25)
                        
                        Button(action: {
                            signUpViewModel.register()
                        }) {
                            Text("Register")
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.top, 25)
                    }
                    .padding(.horizontal, 25)
                            
                }
                        
                Button(action:{
                    self.show.toggle()
                }){
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .foregroundColor(Color.blue)
                }
                .padding()
            }
            
            if signUpViewModel.alert{
                ErrorView(alert: $signUpViewModel.alert, error: $signUpViewModel.error)
            }
        }
            .navigationBarBackButtonHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(show: .constant(false))
    }
}
