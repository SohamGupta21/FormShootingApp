//
//  LoginViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 8/6/21.
//

import Foundation
import SwiftUI
import FirebaseAuth

final class LoginViewModel : ObservableObject {
    
    @Published var color = Color.black.opacity(0.7)
    @Published var email = ""
    @Published var pass = ""
    @Published  var visible = false
    
    @Published var alert = false
    @Published var error = ""
    
    func verify(){
        if self.email != "" && self.pass != ""{
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res,err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                print("success")
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        } else {
            self.error = "Please fill out all of the contents properly."
            self.alert.toggle()
        }
    }
    
    func reset(){
        if self.email != ""{
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                if err != nil{
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}
