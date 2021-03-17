//
//  tfModel.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 24/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//var ModelName = "resnet18False_yoga224_55"
var ModelName = "mobilnetv2False2020-05-11-12-17-45"//resnet18False2021-02-18-10-23-20"

// MARK: - Information about the model file.
public typealias FileInfo = (name: String, extension: String)

public enum tfModel {
  public static let file: FileInfo = (
    name: ModelName, extension: "tflite"
  )

  public static let input = (batchSize: 1, height: 224, width: 224, channelSize: 3)
  public static let output = (batchSize: 1, height: 56, width: 56 , keypointSize: 13, offsetSize: 26)
  public static let isQuantized = false
}
