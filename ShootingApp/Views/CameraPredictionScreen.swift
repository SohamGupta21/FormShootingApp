//
//  CameraPredictionScreen.swift
//  ShootingApp
//
//  Created by soham gupta on 7/30/21.
//

import SwiftUI
import AVKit
import Photos


struct CameraPredictionScreen : View {
    @ObservedObject var dataModel : DataModel
    init(dM: DataModel){
        dataModel = dM
    }
    var body : some View {
        ZStack{
            ImageView(dM: dataModel)
                .aspectRatio(contentMode: .fill)
            VStack{
                HStack {
                    Button(action:{
                    }, label:{
                        Image(systemName: "camera")
                    })
                    Spacer()
                }
                Spacer()

                VStack{
                    Text(dataModel.predictionText)
                        .font(.custom("Helvetica Neue", size: 40))
                        .foregroundColor(.black)
                    Text("\(dataModel.confidenceText)")
                        .font(.custom("Helvetica Neue", size: 40))
                        .foregroundColor(.black)

                }
                .background(Color.gray)
                .cornerRadius(10)
                .opacity(0.5)
                Button(action:{
                    if dataModel.cameraRunning{
                        dataModel.cameraRunning.toggle()
                    }
                }, label:{
                    ZStack{
                        Text("End Workout")
                    }
                })
            }
            .padding()
        }
        .onAppear(perform:{
            UIApplication.shared.isIdleTimerDisabled = true
        })
        .navigationBarHidden(true)
        .navigationBarTitle("", displayMode: .inline)
        .edgesIgnoringSafeArea(.top)
        
        
    }
}

