//
//  SignUpViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 8/6/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
final class SignUpViewModel: ObservableObject {
    @Published var color = Color.black.opacity(0.7)
    @Published var visible = false
    @Published var revisible = false
    @Published var email = ""
    @Published var pass = ""
    @Published var repass = ""
    @Published var username = ""
    @Published var alert = false
    @Published var error = ""
    
    func register(){
        if self.email != ""{
            if self.pass == self.repass{
                Auth.auth().createUser(withEmail: self.email, password: self.pass) {
                    (res,err) in
                    if err != nil{
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    print("success")
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    print(NSNotification.Name("status"))
                }
            } else {
                self.error = "Password Mismatch"
                self.alert.toggle()
            }
        } else {
            self.error = "Please fill all of the contents properly"
            self.alert.toggle()
        }
    }
    
}
