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
                VStack {
                    Text("\(formAnalysis.secondaryShootingArmAngle.rounded(.toNearestOrAwayFromZero))")
                        .foregroundColor(colors.redColor)
                        .font(.largeTitle)
                    Text("Right Arm")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
                VStack {
                    Text("\(formAnalysis.primaryShootingArmAngle.rounded(.toNearestOrAwayFromZero))")
                        .foregroundColor(colors.greenColor)
                        .font(.largeTitle)
                    Text("Left Arm")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
                VStack {
                    Text("+12")
                        .foregroundColor(colors.greenColor)
                        .font(.largeTitle)
                    Text("Back")
                        .foregroundColor(colors.whiteColor)
                }
            }.padding(.all)
            HStack {
                VStack {
                    Text("\(formAnalysis.rightLegAngle.rounded(.toNearestOrAwayFromZero))")
                        .foregroundColor(colors.redColor)
                        .font(.largeTitle)
                    Text("Right Leg")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
                VStack {
                    Text("\(formAnalysis.leftLegAngle.rounded(.toNearestOrAwayFromZero))")
                        .foregroundColor(colors.greenColor)
                        .font(.largeTitle)
                    Text("Left Leg")
                        .foregroundColor(colors.whiteColor)
                }
                Spacer()
                VStack {
                    Text("+12")
                        .foregroundColor(colors.greenColor)
                        .font(.largeTitle)
                    Text("Waist")
                        .foregroundColor(colors.whiteColor)
                }
            }.padding(.all)
        }
        .background(colors.greyColor)
    }
}

//struct AngleComparisonView_Previews: PreviewProvider {
//    static var previews: some View {
//        AngleComparisonView()
//    }
//}
