//
//  FormShootingClassifierExtensions.swift
//  ShootingApp
//
//  Created by soham gupta on 8/9/21.
//

import Foundation
import CoreML

extension FormShootingClassifier {
   
    /// the frame rate of my model
    static let frameRate = 48.0
    
    /// Creates a shared Exercise Classifier instance for the app at launch.
    static let shared: FormShootingClassifier = {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()

        // Create an Exercise Classifier instance.
        guard let exerciseClassifier = try? FormShootingClassifier(configuration: defaultConfig) else {
            // The app requires the action classifier to function.
            fatalError("Exercise Classifier failed to initialize.")
        }

        // Ensure the Exercise Classifier.Label cases match the model's classes.
        exerciseClassifier.checkLabels()

        return exerciseClassifier
    }()

    /// Represents the app's knowledge of the Exercise Classifier model's labels.
    enum Label: String, CaseIterable {
        case form = "Form"


        /// A negative class that represents irrelevant actions.
        case otherAction = "Other"

        /// Creates a label from a string.
        /// - Parameter label: The name of an action class.
        init(_ string: String) {
            guard let label = Label(rawValue: string) else {
                let typeName = String(reflecting: Label.self)
                fatalError("Add the `\(string)` label to the `\(typeName)` type.")
            }

            self = label
        }
    }
    
    /// Ensures the apps knows all of the model's labels at runtime.
    func checkLabels() {
        let metadata = model.modelDescription.metadata
        guard let classLabels = model.modelDescription.classLabels else {
            fatalError("The model doesn't appear to be a classifier.")
        }

        print("Checking the class labels in `\(Self.self)` model:")

        if let author = metadata[.author] {
            print("\tAuthor: \(author)")
        }

        if let description = metadata[.description] {
            print("\tDescription: \(description)")
        }

        if let version = metadata[.versionString] {
            print("\tVersion: \(version)")
        }

        if let license = metadata[.license] {
            print("\tLicense: \(license)")
        }

        print("Labels:")
        for (number, modelLabel) in classLabels.enumerated() {
            guard let modelLabelString = modelLabel as? String else {
                print("The label `\(modelLabel)` is not a string.")
                fatalError("Action classifier labels should be strings.")
            }

            // Ensure ExerciseClassifier.Label supports the model's label.
            let label = Label(modelLabelString)
            print("  \(number): \(label.rawValue)")
        }

        if Label.allCases.count != classLabels.count {
            let difference = Label.allCases.count - classLabels.count
            print("Warning: \(Label.self) contains \(difference) extra class labels.")
        }
    }
    
    /// Returns number of input data samples the model expects in its `poses`
    /// multiarray input to make a prediction. See ExerciseClassifier.mlmodel >
    /// Predictions
    func calculatePredictionWindowSize() -> Int {
        let modelDescription = model.modelDescription

        let modelInputs = modelDescription.inputDescriptionsByName
        assert(modelInputs.count == 1, "The model should have exactly 1 input")

        guard let  input = modelInputs.first?.value else {
            fatalError("The model must have at least 1 input.")
        }

        guard input.type == .multiArray else {
            fatalError("The model's input must be an `MLMultiArray`.")
        }

        guard let multiArrayConstraint = input.multiArrayConstraint else {
            fatalError("The multiarray input must have a constraint.")
        }

        let dimensions = multiArrayConstraint.shape
        guard dimensions.count == 3 else {
            fatalError("The model's input multiarray must be 3 dimensions.")
        }

        let windowSize = Int(truncating: dimensions.first!)
        let frameRate = FormShootingClassifier.frameRate

        let timeSpan = Double(windowSize) / frameRate
        let timeString = String(format: "%0.2f second(s)", timeSpan)
        let fpsString = String(format: "%.0f fps", frameRate)
        print("Window is \(windowSize) frames wide, or \(timeString) at \(fpsString).")

        return windowSize
    }

    /// Predicts an action from a series of landmarks' positions over time.
    /// - Parameter window: An `MLMultiarray` that contains the locations of a
    /// person's body landmarks for multiple points in time.
    /// - Returns: An `ActionPrediction`.
    /// - Tag: predictActionFromWindow
    func predictActionFromWindow(_ window: MLMultiArray) -> ActionPrediction {
        do {
            let output = try prediction(poses: window)
            let action = Label(output.label)
            let confidence = output.labelProbabilities[output.label]!

            return ActionPrediction(label: action.rawValue, confidence: confidence)

        } catch {
            fatalError("Exercise Classifier prediction error: \(error)")
        }
    }
}
