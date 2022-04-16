//
//  InWorkoutView.swift
//  ShootingApp
//
//  Created by Soham Gupta on 4/4/22.
//

import SwiftUI

struct InWorkoutView: View {
    
    @State private var totalShots : String = ""
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: "plus")
                    .font(.headline)
                TextField("50", text: $totalShots)
                    .frame(width: 50, height:50)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .background(Color.white)
                Image(systemName: "minus")
                  .font(.headline)
                Spacer()
            }
            .padding()
            Spacer()
            HStack {
                Spacer()
                TextField("50", text: $totalShots)
                    .frame(width: 100, height:100)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .background(Color.white)
                
                Text("out of")
                
                TextField("50", text: $totalShots)
                    .frame(width: 100, height:100)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .background(Color.white)
                
                Spacer()
            }
            .padding()
            Spacer()
            NavigationButton(destContent: {}, text: "Next")
        }
        .padding()
        .edgesIgnoringSafeArea(.all)
        .background(Color.gray)
    }
}

struct InWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        InWorkoutView()
    }
}
