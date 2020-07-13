//
//  BodyPart.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 24/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

public enum BodyPart: String, CaseIterable {
  case HEAD = "head"
  case LEFT_SHOULDER = "left shoulder"
  case RIGHT_SHOULDER = "right shoulder"
  case LEFT_ELBOW = "left elbow"
  case RIGHT_ELBOW = "right elbow"
  case LEFT_WRIST = "left wrist"
  case RIGHT_WRIST = "right wrist"
  case LEFT_HIP = "left hip"
  case RIGHT_HIP = "right hip"
  case LEFT_KNEE = "left knee"
  case RIGHT_KNEE = "right knee"
  case LEFT_ANKLE = "left ankle"
  case RIGHT_ANKLE = "right ankle"

  /// List of lines connecting each part.
  public static let lines = [
    (from: BodyPart.LEFT_WRIST, to: BodyPart.LEFT_ELBOW),
    (from: BodyPart.LEFT_ELBOW, to: BodyPart.LEFT_SHOULDER),
    (from: BodyPart.LEFT_SHOULDER, to: BodyPart.RIGHT_SHOULDER),
    (from: BodyPart.RIGHT_SHOULDER, to: BodyPart.RIGHT_ELBOW),
    (from: BodyPart.RIGHT_ELBOW, to: BodyPart.RIGHT_WRIST),
    (from: BodyPart.LEFT_SHOULDER, to: BodyPart.LEFT_HIP),
    (from: BodyPart.LEFT_HIP, to: BodyPart.RIGHT_HIP),
    (from: BodyPart.RIGHT_HIP, to: BodyPart.RIGHT_SHOULDER),
    (from: BodyPart.LEFT_HIP, to: BodyPart.LEFT_KNEE),
    (from: BodyPart.LEFT_KNEE, to: BodyPart.LEFT_ANKLE),
    (from: BodyPart.RIGHT_HIP, to: BodyPart.RIGHT_KNEE),
    (from: BodyPart.RIGHT_KNEE, to: BodyPart.RIGHT_ANKLE),
  ]
}
