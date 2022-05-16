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
    var lowestFrame : Pose
    var setPointFrame : Pose
    /// array of pose objects
    init(posesArray : [Pose]){
        self.posesArray = posesArray
        
        self.lowestFrame = FormAnalysis.findLowestFrame(posesArray)
        self.setPointFrame = FormAnalysis.findSetPointFrame(posesArray)
        
        self.computeAngles()
    }
    
    // important data points (angles, etc.) that are being detected
    
    /// primary shooting arm
    var leftArmAngle : Double = 0.0
    /// secondary shooting arm
    var rightArmAngle : Double = 0.0
    /// hip angle
    /// leg angle
    var leftLegAngle : Double = 0.0
    ///right leg angle
    var rightLegAngle : Double = 0.0
    /// helper method to find distance
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    /// computes all of the angles, runs on init
    func computeAngles(){
        computeLeftArmAngle()
        computeRightArmAngle()
        computeLeftLegAngle()
        computeRightLegAngle()
    }
    
    static func findLowestFrame(_ poses : [Pose]) -> Pose {
        var lowestFrame = poses[0]
        var lowestPointY : Double = 2.0
        for pose in poses {
            var rootLocationY = 0.0
            for l in pose.landmarks {
                if l.name == .root{
                    do {
                        try rootLocationY = Double(from: l.location.y as! Decoder)
                    } catch {
                        print("Uh oh")
                    }
                }
            }
            
            if rootLocationY < lowestPointY {
                lowestFrame = pose
                lowestPointY = rootLocationY
            }
        }
        
        return lowestFrame
    }
    
    static func findSetPointFrame(_ poses : [Pose]) -> Pose {
        var setPointPose = poses[0]
        var setPointDistanceX = 2.0
        for pose in poses {
            var leftWrist = CGPoint()
            var leftShoulder = CGPoint()
            
            var rightWrist = CGPoint()
            var rightShoulder = CGPoint()
            
            for l in pose.landmarks {
                if l.name == .leftWrist{
                    leftWrist = l.location
                }
                if l.name == .leftShoulder{
                    leftShoulder = l.location
                }
                if l.name == .rightWrist{
                    rightWrist = l.location
                }
                if l.name == .rightShoulder {
                    rightShoulder = l.location
                }
            }
            
            if leftWrist.y > leftShoulder.y && rightWrist.y > rightShoulder.y {
                if abs(Double(leftWrist.x) - Double(rightWrist.x)) < setPointDistanceX {
                    setPointPose = pose
                    setPointDistanceX = abs(leftWrist.x - rightWrist.x)
                }
            }
        }
        return setPointPose
    }
    // compute individual angles
    func computeLeftArmAngle(){
        var leftShoulder = CGPoint()
        var leftElbow = CGPoint()
        var leftWrist = CGPoint()
        for l in setPointFrame.landmarks {
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
        
        leftArmAngle = angleInDegrees
    }
    
    func computeRightArmAngle(){
        var rightShoulder = CGPoint()
        var rightElbow = CGPoint()
        var rightWrist = CGPoint()
        for l in setPointFrame.landmarks {
            if l.name == .rightShoulder{
                rightShoulder = l.location
            }
            if l.name == .rightElbow{
                rightElbow = l.location
            }
            if l.name == .rightWrist{
                rightWrist = l.location
            }
        }
        // using law of cosines to find the angle
        let a : Double = Double(CGPointDistance(from: rightWrist, to: rightElbow))
        let b : Double = Double(CGPointDistance(from: rightElbow, to: rightShoulder))
        let c : Double = Double(CGPointDistance(from: rightShoulder, to: rightWrist))
        let angleInDegrees = lawOfCosines(a: a, b: b, c: c)
        rightArmAngle = angleInDegrees
    }
    
    func computeLeftLegAngle(){
        var leftHip = CGPoint()
        var leftKnee = CGPoint()
        var leftAngle = CGPoint()
        for l in lowestFrame.landmarks {
            if l.name == .leftHip{
                leftHip = l.location
            }
            if l.name == .leftKnee{
                leftKnee = l.location
            }
            if l.name == .leftAnkle{
                leftAngle = l.location
            }
        }
        // using law of cosines to find the angle
        let a : Double = Double(CGPointDistance(from: leftAngle, to: leftKnee))
        let b : Double = Double(CGPointDistance(from: leftKnee, to: leftHip))
        let c : Double = Double(CGPointDistance(from: leftHip, to: leftAngle))
        let angleInDegrees = lawOfCosines(a: a, b: b, c: c)
        leftLegAngle = angleInDegrees
    }
    
    func computeRightLegAngle(){
        var rightHip = CGPoint()
        var rightKnee = CGPoint()
        var rightAnkle = CGPoint()
        for l in lowestFrame.landmarks {
            if l.name == .rightHip{
                rightHip = l.location
            }
            if l.name == .rightKnee{
                rightKnee = l.location
            }
            if l.name == .rightAnkle{
                rightAnkle = l.location
            }
        }
        // using law of cosines to find the angle
        let a : Double = Double(CGPointDistance(from: rightAnkle, to: rightKnee))
        let b : Double = Double(CGPointDistance(from: rightKnee, to: rightHip))
        let c : Double = Double(CGPointDistance(from: rightHip, to: rightAnkle))
        let angleInDegrees = lawOfCosines(a: a, b: b, c: c)
        rightLegAngle = angleInDegrees
    }
    
    
    // MATHEMATICCSSS

    
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
