//
//  SignUpViewModel.swift
//  ShootingApp
//
//  Created by soham gupta on 8/6/21.
//

import Foundation
import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseFirestore
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
    let db = Firestore.firestore()
    
    func register(){
        if self.email != ""{
            if self.pass == self.repass{
                Auth.auth().createUser(withEmail: self.email, password: self.pass) { [self]
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
                    
                    // add the user to the users section of the database
                    db.collection("users").document(Auth.auth().currentUser?.uid ?? "").setData([
                        "email": self.email,
                        "username": self.username,
                        "teams" : [],
                        "workouts" : [],
                        "workout_log" : [],
                        "ideal_angle" : [["left_arm":0], ["left_leg":0], ["right_arm":0], ["right_leg":0]]
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
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
