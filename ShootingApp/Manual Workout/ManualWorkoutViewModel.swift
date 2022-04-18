//
//  ManualWorkoutViewModel.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/17/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import SwiftUI

class ManualWorkoutViewModel : ObservableObject{
    @Published var workouts : [Workout] = []
    
    let db = Firestore.firestore()
    
    init(){
        loadWorkoutsFromDatabase()
    }
    
    func loadWorkoutsFromDatabase() {
        // get the list of teams that the current user is a part of

        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                for workout in dataDescription["workouts"] as! [String] {
                    // make a database call for information about this team
                    print("WE OUT HERE")
                    print(workout)
                    self.singleWorkoutDatabaseCall(uid: workout)
                }
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func singleWorkoutDatabaseCall(uid: String) {
        let docRef = db.collection("workouts").document(uid)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data()!
                
                let workoutID = uid
                let workoutName = dataDescription["name"] as! String
                
                var workoutDrills = [Drill]()
                
                let workoutDrillsInformation = dataDescription["drills"] as! [[String: String]]
                
                for w in workoutDrillsInformation {
                    print(w)
                    var d = Drill(name: w["drill"] as! String ?? "", amount: Int(w["amount"] as! String)!)
                    workoutDrills.append(d)
                }
                
                self.workouts.append(Workout(id: workoutID, name: workoutName, drills: workoutDrills))

            } else {
                print("Document does not exist")

            }
        }
    }
    
    func saveWorkouProgressIntoLog(workout : Workout) {
        
        var shots_made = 0
        
        for drill in workout.drills {
            shots_made += drill.madeBaskets
        }
        
        var shots_taken = 0
        
        for drill in workout.drills {
            shots_taken += drill.amount
        }
        
        let currentDateTime = Date()

        // initialize the date formatter and set the style
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        
        let workoutLogInfo : [String: String] = [
            "workout_name": workout.name,
            "shots_made": String(shots_made),
            "shots_taken": String(shots_taken),
            "date" : formatter.string(from: currentDateTime)
        ]
        
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.updateData([
            "workout_log": FieldValue.arrayUnion([workoutLogInfo])
        ])
    }
    
    func addNewWorkoutToUser(workoutID : String) {
        let docRef = db.collection("users").document(Auth.auth().currentUser?.uid ?? "")
        
        docRef.updateData([
            "workouts": FieldValue.arrayUnion([workoutID])
        ])
    }
    
    func createNewWorkout(workout : Workout) {
        var drillsArray : [Any] = []
        
        for drill in workout.drills {
            let drillInfo = [
                "name" : drill.name,
                "amount" : String(drill.amount)
            ]
            
            drillsArray.append(drillInfo)
        }
        
        let docData: [String: Any] = [
            "name": workout.name,
            "drills": drillsArray
        ]
                
        let docRef = db.collection("workouts").document(workout.id)
        
        self.addNewWorkoutToUser(workoutID: workout.id)

        docRef.setData(docData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Document successfully written!")
            }
        }
        
        workouts.append(workout)
    }
}
