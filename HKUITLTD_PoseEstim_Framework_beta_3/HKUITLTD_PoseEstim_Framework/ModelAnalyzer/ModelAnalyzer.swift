//
//  ModelAnalyzer.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 24/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Accelerate
import CoreImage
import Foundation
import UIKit


public class ModelAnalyzer {
  // MARK: - Private Properties

  /// TensorFlow Lite `Interpreter` object for performing inference on a given model.
  private var interpreter: Interpreter

  /// TensorFlow lite `Tensor` of model input and output.
  private var inputTensor: Tensor

  private var heatsTensor: Tensor
//  private var offsetsTensor: Tensor

    /// Constants for calculating alpha
    private let minBound:CGFloat = 0.3
    private let maxBound:CGFloat = 0.8
    
    private let q = DispatchQueue(label: "extract queue", attributes: .concurrent)
    private let g = DispatchGroup()
  // MARK: - Initialization

  /// A failable initializer for `ModelDataHandler`. A new instance is created if the model is
  /// successfully loaded from the app's main bundle. Default `threadCount` is 2.
  public init(
    threadCount: Int = Constants.defaultThreadCount,
    delegate: Delegates = Constants.defaultDelegate
  ) throws {
    // Construct the path to the model file.


    guard
        let modelPath = Bundle(identifier: "HKUITLTD.HKUITLTD-PoseEstim-Framework")?.path(
        forResource: tfModel.file.name,
        ofType: tfModel.file.extension
      )
    else {
      fatalError("Failed to load the model file with name: \(tfModel.file.name).")

    }

    // Specify the options for the `Interpreter`.
    var options = Interpreter.Options()
    options.threadCount = threadCount

    // Specify the delegates for the `Interpreter`.
    var delegates: [Delegate]?
    switch delegate {
    case .Metal:
      delegates = [MetalDelegate()]
    default:
      delegates = nil
    }

    // Create the `Interpreter`.
    interpreter = try Interpreter(modelPath: modelPath, options: options, delegates: delegates)

    // Initialize input and output `Tensor`s.
    // Allocate memory for the model's input `Tensor`s.
    try interpreter.allocateTensors()

    // Get allocated input and output `Tensor`s.
    inputTensor = try interpreter.input(at: 0)
    heatsTensor = try interpreter.output(at: 0)

    // Check if input and output `Tensor`s are in the expected formats.
    guard (inputTensor.dataType == .uInt8) == tfModel.isQuantized else {
      fatalError("Unexpected Model: quantization is \(!tfModel.isQuantized)")
    }

    guard inputTensor.shape.dimensions[0] == tfModel.input.batchSize,
      inputTensor.shape.dimensions[1] == tfModel.input.height,
      inputTensor.shape.dimensions[2] == tfModel.input.width,
      inputTensor.shape.dimensions[3] == tfModel.input.channelSize
    else {
      fatalError("Unexpected Model: input shape")
    }

    guard heatsTensor.shape.dimensions[0] == tfModel.output.batchSize,
      heatsTensor.shape.dimensions[1] == tfModel.output.height,
      heatsTensor.shape.dimensions[2] == tfModel.output.width,
      heatsTensor.shape.dimensions[3] == tfModel.output.keypointSize + tfModel.output.offsetSize
    else {
      fatalError("Unexpected Model: heat tensor")
    }

  }
    
  /// Runs model with given image with given source area to destination area.
  ///
  /// - Parameters:
  ///   - on: Input image to run the model.
  ///   - from: Range of input image to run the model.
  ///   - to: Size of view to render the result.
  /// - Returns: Result of the inference and the times consumed in every steps.
  public func runPoseNet(on pixelbuffer: CVPixelBuffer, from source: CGRect, to dest: CGSize)
    -> (Result, Times)?
  {
    // Start times of each process.
    let preprocessingStartTime: Date
    let inferenceStartTime: Date
    let postprocessingStartTime: Date

    // Processing times in miliseconds.
    let preprocessingTime: TimeInterval
    let inferenceTime: TimeInterval
    let postprocessingTime: TimeInterval

    preprocessingStartTime = Date()
    guard let data = preprocess(of: pixelbuffer, from: source) else {
      os_log("Preprocessing failed", type: .error)
      return nil
    }
    preprocessingTime = Date().timeIntervalSince(preprocessingStartTime) * 1000

    inferenceStartTime = Date()
    inference(from: data)
    inferenceTime = Date().timeIntervalSince(inferenceStartTime) * 1000

    postprocessingStartTime = Date()
    guard let result = postprocess(to: dest) else {
      os_log("Postprocessing failed", type: .error)
      return nil
    }
    postprocessingTime = Date().timeIntervalSince(postprocessingStartTime) * 1000

    let times = Times(
      preprocessing: preprocessingTime,
      inference: inferenceTime,
      postprocessing: postprocessingTime)
    return (result, times)
  }

  // MARK: - Private functions to run model
  /// Preprocesses given rectangle image to be `Data` of disired size by croping and resizing it.
  ///
  /// - Parameters:
  ///   - of: Input image to crop and resize.
  ///   - from: Target area to be cropped and resized.
  /// - Returns: The cropped and resized image. `nil` if it can not be processed.
  private func preprocess(of pixelBuffer: CVPixelBuffer, from targetSquare: CGRect) -> Data? {
    let sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer)
    assert(sourcePixelFormat == kCVPixelFormatType_32BGRA)

    // Resize `targetSquare` of input image to `modelSize`.
    let modelSize = CGSize(width: tfModel.input.width, height: tfModel.input.height)
    guard let thumbnail = pixelBuffer.resize(from: targetSquare, to: modelSize)
    else {
      return nil
    }

    // Remove the alpha component from the image buffer to get the initialized `Data`.
    let byteCount =
      tfModel.input.batchSize
      * tfModel.input.height * tfModel.input.width
      * tfModel.input.channelSize
    guard
      let inputData = thumbnail.rgbData(
        byteCount: byteCount,
        isModelQuantized: tfModel.isQuantized
      )
    else {
      os_log("Failed to convert the image buffer to RGB data.", type: .error)
      return nil
    }

    return inputData
  }

  /// Postprocesses output `Tensor`s to `Result` with size of view to render the result.
  ///
  /// - Parameters:
  ///   - to: Size of view to be displaied.
  /// - Returns: Postprocessed `Result`. `nil` if it can not be processed.
  private func postprocess(to viewSize: CGSize) -> Result? {
    
    // MARK: Formats output tensors
    // Convert `Tensor` to `FlatArray`. As PoseNet is not quantized, convert them to Float type `FlatArray`.
    let heats = FlatArray<Float32>(tensor: heatsTensor)
    

    let findPosTime = Date()
    // MARK: Find position of each key point
    // Finds the (row, col) locations of where the keypoints are most likely to be. The highest
    // `heats[0, row, col, keypoint]` value, the more likely `keypoint` being located in (`row`, `col`).
    
    // MARK: Single thread code
    //    let keypointPositions = (0..<tfModel.output.keypointSize).map { keypoint -> (Int, Int) in
    //    var maxValue = heats[0, 0, 0, keypoint]
    //    var maxRow = 0
    //    var maxCol = 0
    //    for row in 0..<tfModel.output.height {
    //      for col in 0..<tfModel.output.width {
    //        if heats[0, row, col, keypoint] > maxValue {
    //          maxValue = heats[0, row, col, keypoint]
    //          maxRow = row
    //          maxCol = col
    //        }
    //      }
    //    }
    //    return (maxRow, maxCol)
    //  }
    
    // MARK: Multithread code
//    var kps1 = [(Int, Int)]()
//    var kps2 = [(Int, Int)]()
//    var kps3 = [(Int, Int)]()
//    var kps4 = [(Int, Int)]()
//
//    self.g.enter()
//    self.q.async {
//        kps1 = (0..<3).map { keypoint -> (Int, Int) in
//        var maxValue = heats[0, 0, 0, keypoint]
//        var maxRow = 0
//        var maxCol = 0
//        for row in 0..<tfModel.output.height {
//          for col in 0..<tfModel.output.width {
//            if heats[0, row, col, keypoint] > maxValue {
//              maxValue = heats[0, row, col, keypoint]
//              maxRow = row
//              maxCol = col
//            }
//          }
//        }
//        return (maxRow, maxCol)
//      }
//        print(1)
//        self.g.leave()
//    }
//    self.g.enter()
//    self.q.async {
//        kps2 = (3..<6).map { keypoint -> (Int, Int) in
//        var maxValue = heats[0, 0, 0, keypoint]
//        var maxRow = 0
//        var maxCol = 0
//        for row in 0..<tfModel.output.height {
//          for col in 0..<tfModel.output.width {
//            if heats[0, row, col, keypoint] > maxValue {
//              maxValue = heats[0, row, col, keypoint]
//              maxRow = row
//              maxCol = col
//            }
//          }
//        }
//        return (maxRow, maxCol)
//      }
//        print(2)
//        self.g.leave()
//    }
//    self.g.enter()
//    self.q.async {
//        kps3 = (6..<9).map { keypoint -> (Int, Int) in
//        var maxValue = heats[0, 0, 0, keypoint]
//        var maxRow = 0
//        var maxCol = 0
//        for row in 0..<tfModel.output.height {
//          for col in 0..<tfModel.output.width {
//            if heats[0, row, col, keypoint] > maxValue {
//              maxValue = heats[0, row, col, keypoint]
//              maxRow = row
//              maxCol = col
//            }
//          }
//        }
//        return (maxRow, maxCol)
//      }
//        print(3)
//        self.g.leave()
//    }
//    self.g.enter()
//    self.q.async {
//        kps4 = (9..<13).map { keypoint -> (Int, Int) in
//        var maxValue = heats[0, 0, 0, keypoint]
//        var maxRow = 0
//        var maxCol = 0
//        for row in 0..<tfModel.output.height {
//          for col in 0..<tfModel.output.width {
//            if heats[0, row, col, keypoint] > maxValue {
//              maxValue = heats[0, row, col, keypoint]
//              maxRow = row
//              maxCol = col
//            }
//          }
//        }
//        return (maxRow, maxCol)
//      }
//        print(4)
//        self.g.leave()
//    }
//    self.g.wait()
//    let keypointPositions = kps1 + kps2 + kps3 + kps4
    
    // MARK: Multithread code II
        let keypointPositions = (0..<tfModel.output.keypointSize).map { keypoint -> (Int, Int) in
            var quad1 = (0, 0)
            var quad1_score:Float32 = 0.0
            var quad2 = (0, 0)
            var quad2_score:Float32 = 0.0
            var quad3 = (0, 0)
            var quad3_score:Float32 = 0.0
            var quad4 = (0, 0)
            var quad4_score:Float32 = 0.0
            var maxValue = heats[0, 0, 0, keypoint]
            var maxRow = 0
            var maxCol = 0
            self.g.enter()
            self.q.async {
                for row in 0..<28 {
                    for col in 0..<28 {
                        if heats[0, row, col, keypoint] > maxValue {
                          maxValue = heats[0, row, col, keypoint]
                          maxRow = row
                          maxCol = col
                        }
                    }
                }
                quad1 = (maxRow, maxCol)
                quad1_score = maxValue
                self.g.leave()
            }
            self.g.enter()
            self.q.async {
                for row in 28..<56 {
                    for col in 0..<28 {
                        if heats[0, row, col, keypoint] > maxValue {
                          maxValue = heats[0, row, col, keypoint]
                          maxRow = row
                          maxCol = col
                        }
                    }
                }
                quad2 = (maxRow, maxCol)
                quad2_score = maxValue
                self.g.leave()
            }
            self.g.enter()
            self.q.async {
                for row in 0..<28 {
                    for col in 28..<56 {
                        if heats[0, row, col, keypoint] > maxValue {
                          maxValue = heats[0, row, col, keypoint]
                          maxRow = row
                          maxCol = col
                        }
                    }
                }
                quad3 = (maxRow, maxCol)
                quad3_score = maxValue
                self.g.leave()
            }
            self.g.enter()
            self.q.async {
                for row in 28..<56 {
                    for col in 28..<56 {
                        if heats[0, row, col, keypoint] > maxValue {
                          maxValue = heats[0, row, col, keypoint]
                          maxRow = row
                          maxCol = col
                        }
                    }
                }
                quad4 = (maxRow, maxCol)
                quad4_score = maxValue
                self.g.leave()
            }
            g.wait()
            let compVal = [quad1_score, quad2_score, quad3_score, quad4_score]
            let compCoord = [quad1, quad2, quad3, quad4]
            let maxVal = compVal.max()
            var i = 0
            for score in compVal {
                if score == maxVal {
                    return compCoord[i]
                }
                i += 1
            }
            return (0, 0)
      }
    
    
    let finPosProcessingTime = Date().timeIntervalSince(findPosTime) * 1000
    print("extract time: ", finPosProcessingTime)
//    print(keypointPositions)

    // MARK: Calculates total confidence score
    // Calculates total confidence score of each key position.
    let totalScoreSum = keypointPositions.enumerated().reduce(0.0) { accumulator, elem -> Float32 in
      accumulator + sigmoid(heats[0, elem.element.0, elem.element.1, elem.offset])
    }
    let totalScore = totalScoreSum / Float32(tfModel.output.keypointSize)

    // MARK: Calculate key point position on model input
    // Calculates `KeyPoint` coordination model input image with `offsets` adjustment.
    let coords = keypointPositions.enumerated().map { index, elem -> (y: Float32, x: Float32) in
        let (y, x) = elem
        var yCoord = Float32(0)
        var xCoord = Float32(0)
    // MARK: Change the output if the model has both heatmap and offset
        if(tfModel.output.offsetSize != 0){
            yCoord = Float32(y) / Float32(tfModel.output.height - 1) * Float32(tfModel.input.height)+heats[0, x, y, index+26]
            xCoord = Float32(x) / Float32(tfModel.output.width - 1) * Float32(tfModel.input.width)+heats[0, x, y, index+13]}
        else{
            yCoord = Float32(y) / Float32(tfModel.output.height - 1) * Float32(tfModel.input.height)
            xCoord = Float32(x) / Float32(tfModel.output.width - 1) * Float32(tfModel.input.width)
        }

      return (y: yCoord, x: xCoord)
    }
    
    // MARK: Transform key point position and make lines
    // Make `Result` from `keypointPosition'. Each point is adjusted to `ViewSize` to be drawn.
    var result = Result(dots: [], lines: [],shapes: [], score: totalScore)
    var bodyPartToDotMap = [BodyPart: CGPoint]()
    for (index, part) in BodyPart.allCases.enumerated() {
        if index < 13
        {
            let position = CGPoint(
              x: CGFloat(coords[index].x) * viewSize.width / CGFloat(tfModel.input.width),
              y: CGFloat(coords[index].y) * viewSize.height / CGFloat(tfModel.input.height)
            )
            
            bodyPartToDotMap[part] = position
            result.dots.append(position)
        }
    }
    
    do {
      try result.lines = BodyPart.lines.map { map throws -> Line in
        guard let from = bodyPartToDotMap[map.from] else {
          throw PostprocessError.missingBodyPart(of: map.from)
        }
        guard let to = bodyPartToDotMap[map.to] else {
          throw PostprocessError.missingBodyPart(of: map.to)
        }
        return Line(from: from, to: to)
      }
    } catch PostprocessError.missingBodyPart(let missingPart) {
      os_log("Postprocessing error: %s is missing.", type: .error, missingPart.rawValue)
      return nil
    } catch {
      os_log("Postprocessing error: %s", type: .error, error.localizedDescription)
      return nil
    }
    
    return result
  }

  /// Run inference with given `Data`
  ///
  /// Parameter `from`: `Data` of input image to run model.
  private func inference(from data: Data) {
    // Copy the initialized `Data` to the input `Tensor`.
    do {
      try interpreter.copy(data, toInputAt: 0)

      // Run inference by invoking the `Interpreter`.
      try interpreter.invoke()

      // Get the output `Tensor` to process the inference results.
      heatsTensor = try interpreter.output(at: 0)
      //offsetsTensor = try interpreter.output(at: 1)

    } catch let error {
      os_log(
        "Failed to invoke the interpreter with error: %s", type: .error,
        error.localizedDescription)
      return
    }
  }

  /// Returns value within [0,1].
  private func sigmoid(_ x: Float32) -> Float32 {
    return (1.0 / (1.0 + exp(-x)))
  }
    
}

// MARK: - Custom Errors
public enum PostprocessError: Error {
  case missingBodyPart(of: BodyPart)
}





