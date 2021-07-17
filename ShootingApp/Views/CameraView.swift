
//
//  CameraScreen.swift
//  QuickDictionary
//
//  Created by soham gupta on 6/13/21.
//
import SwiftUI
import AVFoundation
import Vision

struct CameraView: View{
    
    @StateObject var camera = CameraModel()
    init(){
        UIApplication.shared.isIdleTimerDisabled = true
    }
    var body: some View {
        NavigationView {
            ZStack{
                CameraPreview(camera: camera)
                    .ignoresSafeArea(.all, edges: .all)
                Text(camera.currentPrediction)
                    .background(Color.blue)
            }
            .onAppear(perform:{
                camera.Check()
            })
            .navigationBarHidden(true)
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}


struct CameraView_Previews: PreviewProvider {
    static var previews: some View {
        CameraView()
    }
}

struct CameraPreview: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator(cameraModel: camera)
    }
    
    
    @ObservedObject var camera: CameraModel
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame:UIScreen.main.bounds)
        camera.predictor.delegate = context.coordinator
        camera.preview = AVCaptureVideoPreviewLayer(session: camera.session)
        camera.preview.frame = view.frame
        
        view.layer.addSublayer(camera.preview)

        view.layer.addSublayer(camera.pointsLayer)
        camera.pointsLayer.frame = view.frame
        camera.pointsLayer.strokeColor = UIColor.green.cgColor
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        return
    }
    
    class Coordinator: NSObject, PredictorDelegate {
        func predictor(_ predictor: Predictor, didLabelAction action: String, with confidence: Double) {
            
            
            //camera.currentPrediction = action
        }
        
        @ObservedObject var camera: CameraModel
        init(cameraModel: CameraModel){
            camera = cameraModel
            super.init()
        }
        func predictor(_ predictor: Predictor, didFindNewRecognizedPoints points: [CGPoint]) {
            guard case camera.preview = camera.preview else {return}
            let convertedPoints = points.map {
                camera.preview.layerPointConverted(fromCaptureDevicePoint: $0)
            }
            
            let combinedPath = CGMutablePath()
            
            for point in convertedPoints {
                let dotPath = UIBezierPath(ovalIn: CGRect(x: point.x, y: point.y, width: 10, height:10))
                combinedPath.addPath(dotPath.cgPath)
            }
            camera.pointsLayer.path = combinedPath
            
            DispatchQueue.main.async {
                self.camera.pointsLayer.didChangeValue(for: \.path)
            }
        }
    }
}
