//
//  InWorkoutView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/4/22.
//

import SwiftUI

struct InWorkoutView: View {
    
    @State private var madeShots : String = ""
    
    @State var workout : Workout
    
    @State var index = 0
    
    @ObservedObject var manualWorkoutViewModel : ManualWorkoutViewModel
    
    var body: some View {
        VStack {
//            HStack {
//                Spacer()
//                Image(systemName: "plus")
//                    .font(.headline)
//                TextField("50", text: $totalShots)
//                    .frame(width: 50, height:50)
//                    .multilineTextAlignment(.center)
//                    .keyboardType(.numberPad)
//                    .background(Color.white)
//                Image(systemName: "minus")
//                  .font(.headline)
//                Spacer()
//            }
//            .padding()
            
            Text(workout.drills[index].name)
                .font(.title)
            Spacer()
            HStack {
                Spacer()
                TextField("0", text: $madeShots)
                    .frame(width: 100, height:100)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .background(Color.white)
                
                Text("out of")
                
                
                Text("\(workout.drills[index].amount)")
                    .font(.title)
                //TextField("50", text: $totalShots)
//                    .frame(width: 100, height:100)
//                    .multilineTextAlignment(.center)
//                    .keyboardType(.numberPad)
//                    .background(Color.white)
                
                Spacer()
            }
            .padding()
            Spacer()
            
            Button(action: {
                workout.drills[index].madeBaskets = Int(madeShots) ?? 0
                if index < workout.drills.count - 1{
                    index += 1
                }
            }, label: {
                Text("Finish Drill")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            })
            .background(Colors().orangeColor)
            .cornerRadius(50)
            .padding(.top, 25)
            
            if index >= workout.drills.count - 1 {
                NavigationLink(destination: {
                    ManualWorkoutCompletedSummaryView(workout: workout, mWVM: manualWorkoutViewModel)
                }, label:{
                    Text("Finish Workout")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                })
                .background(Colors().orangeColor)
                .cornerRadius(50)
                .padding(.top, 25)
            }
        }
        .padding()
        .background(Color.gray)
    }
}

//struct InWorkoutView_Previews: PreviewProvider {
//    static var previews: some View {
//        InWorkoutView()
//    }
//}
