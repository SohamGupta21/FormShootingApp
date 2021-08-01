import SwiftUI
import AVFoundation
import Vision
import AVKit
import Photos

struct BodyPredictionScreen: View {
    @ObservedObject var dataModel = DataModel()
    var body: some View {
        if dataModel.cameraRunning {
            CameraPredictionScreen(dM: dataModel)
        } else {
            FormReviewController(dataModel: dataModel,currentVideo: dataModel.formShootingFrames[0])
        }
    }

}
