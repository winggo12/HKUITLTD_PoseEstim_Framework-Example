//
//  tfModel.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 24/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//var ModelName = "resnet18False_yoga224_55"
var ModelName = "mobilenetv2False2021-03-26-10-46-16"
//var ModelName = "mv2up56gray"
let kpsNo = 9
let colorScheme = 1 // 0: gray, 1: rgb

// MARK: - Information about the model file.
public typealias FileInfo = (name: String, extension: String)

public enum tfModel {
  public static let file: FileInfo = (
    name: ModelName, extension: "tflite"
  )

  public static let input = (batchSize: 1, height: 224, width: 224, channelSize: 3)
//  public static let output = (batchSize: 1, height: 112, width: 112 , keypointSize: kpsNo, offsetSize: 2*kpsNo)
  public static let output = (batchSize: 1, height: 56, width: 56 , keypointSize: kpsNo, offsetSize: 2*kpsNo)
//  public static let output = (batchSize: 1, height:224, width:224, keypointSize: kpsNo, offsetSize: 2*kpsNo)
  public static let isQuantized = false
    
  public static let color = colorScheme
}
