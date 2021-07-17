//
//  CameraModel.swift
//  ShootingApp
//
//  Created by soham gupta on 7/8/21.
//

import Foundation
import AVFoundation
import UIKit

class CameraModel: NSObject, ObservableObject, AVCapturePhotoCaptureDelegate{
    
    
    @Published var isTaken = false
    
    @Published var session = AVCaptureSession()
    
    @Published var alert = false
    
    @Published var videoOutput = AVCaptureVideoDataOutput()
    
    @Published var preview = AVCaptureVideoPreviewLayer()
    
    @Published var pointsLayer = CAShapeLayer()
    
    @Published var currentPrediction = ""
    
    @Published var isSaved = false
   
    @Published var picData = Data(count: 0)
    
    @Published var predictor = Predictor()

    func Check(){
        switch AVCaptureDevice.authorizationStatus(for: .video){
        case.authorized:
            setUp()
            return
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video){ (status) in
                if status{
                    self.setUp()
                }
            }
        case .denied:
            self.alert.toggle()
            return
        default:
            return
        }
    }
    
    func setUp(){
        do{
            self.session.beginConfiguration()
            
            let device = AVCaptureDevice.default(.builtInWideAngleCamera,for:.video, position:.front)
            
            let input = try AVCaptureDeviceInput(device:device!)
            
            if self.session.canAddInput(input){
                self.session.addInput(input)
            }
            
            if self.session.canAddOutput(self.videoOutput){
                self.session.addOutput(self.videoOutput)
                self.videoOutput.alwaysDiscardsLateVideoFrames = true
            }
            
            self.session.commitConfiguration()
            
            
            self.session.startRunning()
            self.videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoDispatchQueue"))
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
extension CameraModel: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        predictor.estimation(sampleBuffer: sampleBuffer)
    }
}
