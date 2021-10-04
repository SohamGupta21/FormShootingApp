//
//  FormAnalysis.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import Foundation
import Vision
/// this class will use landmarks from body detection to find angles and distances that are relevant for shooting form analysis
class FormAnalysis {
    
    /// should take in the pose landmarks of a shot as an array
    /// this is an array of the most prominent pose per frame, not all of the poses in a frame
    var posesArray : [Pose]
    /// array of pose objects
    init(posesArray : [Pose]){
        self.posesArray = posesArray
        self.computeAngles()
    }
    
    // important data points (angles, etc.) that are being detected
    
    /// primary shooting arm
    var primaryShootingArmAngle : Double = 0.0
    /// secondary shooting arm
    var secondaryShootingArmAngle : Double = 0.0
    /// hip angle
    var hipAngle : Double = 0.0
    /// leg angle
    var legAngle : Double = 0.0
    /// knee to knee distance
    var kneeToKneeDistance : Double = 0.0
    /// helper method to find distance
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    /// computes all of the angles, runs on init
    func computeAngles(){
        computePrimaryShootingArmAngle()
    }
    
    // compute individual angles
    func computePrimaryShootingArmAngle(){
        var computedAngles : [Double] = []
        for pose in self.posesArray {
            var leftShoulder = CGPoint()
            var leftElbow = CGPoint()
            var leftWrist = CGPoint()
            for l in pose.landmarks {
                if l.name == .leftShoulder{
                    leftShoulder = l.location
                }
                if l.name == .leftElbow{
                    leftElbow = l.location
                }
                if l.name == .leftWrist{
                    leftWrist = l.location
                }
            }
            // using law of cosines to find the angle
            let a : Double = Double(CGPointDistance(from: leftWrist, to: leftElbow))
            let b : Double = Double(CGPointDistance(from: leftElbow, to: leftShoulder))
            let c : Double = Double(CGPointDistance(from: leftShoulder, to: leftWrist))
            let angleInDegrees = lawOfCosines(a: a, b: b, c: c)
            computedAngles.append(abs(angleInDegrees))
        }
        primaryShootingArmAngle = (Double) (computedAngles.reduce(0, +)) / (Double) (computedAngles.count)
    }
    
    func lawOfCosines(a : Double, b:Double, c:Double) -> Double{
        // c^2 = a^2 + b^2 -2abcosC
        // (c^2 - a^2 - b^2)/(-2ab) = cosC
        let a_squared = pow(a, 2)
        let b_squared = pow(b, 2)
        let c_squared = pow(c, 2)
        
        let numerator = c_squared - a_squared - b_squared
        let denominator = -2 * a * b
        
        let angleC = numerator/denominator
        
        return acos(angleC)*180/Double.pi
    }
}
