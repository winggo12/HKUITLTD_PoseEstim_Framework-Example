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
    // Convert `Tensor` to `FlatArray`. As PoseNet is not quantized, convert them to Float type
    // `FlatArray`.
    let heats = FlatArray<Float32>(tensor: heatsTensor)
//    let offsets = FlatArray<Float32>(tensor: offsetsTensor)

    // MARK: Find position of each key point
    // Finds the (row, col) locations of where the keypoints are most likely to be. The highest
    // `heats[0, row, col, keypoint]` value, the more likely `keypoint` being located in (`row`,
    // `col`).
    let keypointPositions = (0..<tfModel.output.keypointSize).map { keypoint -> (Int, Int) in
      var maxValue = heats[0, 0, 0, keypoint]
      var maxRow = 0
      var maxCol = 0
      for row in 0..<tfModel.output.height {
        for col in 0..<tfModel.output.width {
          if heats[0, row, col, keypoint] > maxValue {
            maxValue = heats[0, row, col, keypoint]
            maxRow = row
            maxCol = col
          }
        }
      }
      return (maxRow, maxCol)
    }

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
    
    /// Additional keypoints
//    let leftArmTri = centroidV2(v1: result.dots[1], v2: result.dots[3], v3: result.dots[5])
//    let rightArmTri = centroidV2(v1: result.dots[2], v2: result.dots[4], v3: result.dots[6])
//    let leftLegTri = centroidV2(v1: result.dots[7], v2: result.dots[9], v3: result.dots[11])
//    let rightLegTri = centroidV2(v1: result.dots[8], v2: result.dots[10], v3: result.dots[12])
//    let leftBodyCen = centerPoint(p1: result.dots[1], p2: result.dots[7])
//    let rightBodyCen = centerPoint(p1: result.dots[2], p2: result.dots[8])
//    bodyPartToDotMap[BodyPart.LEFT_ARM_TRI] = leftArmTri
//    result.dots.append(leftArmTri)
//    bodyPartToDotMap[BodyPart.RIGHT_ARM_TRI] = rightArmTri
//    result.dots.append(rightArmTri)
//    bodyPartToDotMap[BodyPart.LEFT_LEG_TRI] = leftLegTri
//    result.dots.append(leftLegTri)
//    bodyPartToDotMap[BodyPart.RIGHT_LEG_TRI] = rightLegTri
//    result.dots.append(rightLegTri)
//    bodyPartToDotMap[BodyPart.LEFT_BODY_CEN] = leftBodyCen
//    result.dots.append(leftBodyCen)
//    bodyPartToDotMap[BodyPart.RIGHT_BODY_CEN] = rightBodyCen
//    result.dots.append(rightBodyCen)
    ///
    
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
    
    /// Additional shapes element
//    // Drawing shapes
//    let noColorShapes = BodyPart.shapes.map{ (shapes) -> (CAShapeLayer, [CGPoint]) in
//        let layer = CAShapeLayer()
//        let path = UIBezierPath()
//        var points = [CGPoint]()
//        for (index, shape) in shapes.enumerated() {
//            if index == 0 {
//                path.move(to: result.dots[shape])
//                points.append(result.dots[shape])
//            } else {
//                path.addLine(to: result.dots[shape])
//                points.append(result.dots[shape])
//            }
//        }
//        path.close()
//        layer.path = path.cgPath
//        return (layer, points)
//    }
//    // Calculating area of each shapes
//    var bound = [CGFloat]()
//    noColorShapes.forEach{
//        bound.append(findArea(polygon: $1))
//        result.shapes.append($0)
//    }
//    // Normalize area
//    let max = bound.max()
//    let min = bound.min()
//    // Fill the shapes corr. areas
//    for i in 0...result.shapes.count - 1 {
//        result.shapes[i].fillColor = UIColor(red: CGFloat(1 - result.score), green: CGFloat(0 + result.score), blue: 0, alpha: CGFloat(0.7 * (bound[i] - min!) * (maxBound - minBound) / (max! - min!) + minBound)).cgColor
//    }
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
    
    /// additional functions 11/11/2020
    private func orthocenter(v1: CGPoint, v2: CGPoint, v3: CGPoint)->CGPoint {
        var ortho: CGPoint = CGPoint(x: 0, y: 0)
        ortho.x = ((v2.x * (v1.x - v3.x) + v2.y * (v1.y - v3.y)) * (v3.y - v2.y) - (v3.y - v1.y) * (v1.x * (v2.x - v3.x) + v1.y * (v2.y - v3.y))) / ((v3.x - v2.x) * (v3.y - v1.y) - (v3.y - v2.y) * (v3.x - v1.x))
        ortho.y = ((v2.x * (v1.x - v3.x) + v2.y * (v1.y - v3.y)) * (v3.x - v2.x) - (v3.x - v1.x) * (v1.x * (v2.x - v3.x) + v1.y * (v2.y - v3.y))) / ((v3.y - v2.y) * (v3.x - v1.x) - (v3.x - v2.x) * (v3.y - v1.y))
        return ortho
    }
    
    private func centroidV2(v1: CGPoint, v2: CGPoint, v3: CGPoint)->CGPoint {
        var cent = CGPoint(x: 0, y: 0)
        cent.x = ((v1.x + v2.x + v3.x) / 3 + v2.x) / 2
        cent.y = ((v1.y + v2.y + v3.y) / 3 + v2.y) / 2
        return cent
    }
    
    private func findArea(polygon: [CGPoint]) -> CGFloat {
        var area: CGFloat = 0.0
        for i in 0...polygon.count - 2 {
            area += polygon[i].x * polygon[i+1].y - polygon[i+1].x * polygon[i].y
        }
        area += polygon[polygon.count-1].x * polygon[0].y - polygon[0].x * polygon[polygon.count-1].y
        area = abs(area) / 2
        return area
    }
    
    private func centerPoint(p1: CGPoint, p2: CGPoint)->CGPoint {
        var cent = CGPoint(x: 0, y: 0)
        cent.x = (p1.x + p2.x) / 2
        cent.y = (p1.y + p2.y) / 2
        return cent
    }
    
}

// MARK: - Custom Errors
public enum PostprocessError: Error {
  case missingBodyPart(of: BodyPart)
}





