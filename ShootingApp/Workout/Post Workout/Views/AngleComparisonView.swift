//
//  AngleComparisonView.swift
//  ShootingApp
//
//  Created by soham gupta on 10/21/21.
//

import SwiftUI

struct AngleComparisonView: View {
    var colors = Colors()
    var formAnalysis : FormAnalysis
    var body: some View {
        VStack {
            Text("Angles")
                .foregroundColor(colors.whiteColor)
                .fontWeight(.bold)
                .font(.title)
            HStack {
                Spacer()
                VStack {
                    Text("\(Int(formAnalysis.rightArmAngle))")
                        .foregroundColor(colors.orangeColor)
                        .font(.largeTitle)
                    Text("Right Arm")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
                VStack {
                    Text("\(Int(formAnalysis.leftArmAngle))")
                        .foregroundColor(colors.orangeColor)
                        .font(.largeTitle)
                    Text("Left Arm")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
            }.padding(.all)
            HStack {
                Spacer()
                VStack {
                    Text("\(Int(formAnalysis.rightLegAngle))")
                        .foregroundColor(colors.orangeColor)
                        .font(.largeTitle)
                    Text("Right Leg")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
                VStack {
                    Text("\(Int(formAnalysis.leftLegAngle))")
                        .foregroundColor(colors.orangeColor)
                        .font(.largeTitle)
                    Text("Left Leg")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
            }.padding(.all)
        }
    }
}

//struct AngleComparisonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AngleComparisonView()
//    }
//}
