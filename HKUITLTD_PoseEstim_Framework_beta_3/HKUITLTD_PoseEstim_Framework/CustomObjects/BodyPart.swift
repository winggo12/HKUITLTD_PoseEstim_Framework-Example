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
    // some new points are calculated in ModelAnalyzer.swift
    // try draw shape instead of line in OverlayView.swift
    case LEFT_ARM_TRI = "left_arm_tri"
    case RIGHT_ARM_TRI = "right_arm_tri"
    case LEFT_LEG_TRI = "left_leg_tri"
    case RIGHT_LEG_TRI = "right_leg_tri"
    case LEFT_BODY_CEN = "left_body_cen"
    case RIGHT_BODY_CEN = "right_body_cen"

  /// List of lines connecting each part.
  public static let lines = [
    // Foundamental Lines
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
    
    // Additional lines
//    (from: BodyPart.LEFT_ELBOW, to: BodyPart.RIGHT_SHOULDER),
//    (from: BodyPart.RIGHT_ELBOW, to: BodyPart.LEFT_SHOULDER),
//    (from: BodyPart.LEFT_KNEE, to: BodyPart.RIGHT_HIP),
//    (from: BodyPart.LEFT_HIP, to: BodyPart.RIGHT_KNEE),
//
//    // Additional Intermediate lines
//    (from: BodyPart.LEFT_SHOULDER, to: BodyPart.LEFT_ARM_TRI),
//    (from: BodyPart.LEFT_ARM_TRI, to: BodyPart.LEFT_WRIST),
//    (from: BodyPart.RIGHT_SHOULDER, to: BodyPart.RIGHT_ARM_TRI),
//    (from: BodyPart.RIGHT_ARM_TRI, to: BodyPart.RIGHT_WRIST),
//    (from: BodyPart.LEFT_HIP, to: BodyPart.LEFT_LEG_TRI),
//    (from: BodyPart.LEFT_LEG_TRI, to: BodyPart.LEFT_ANKLE),
//    (from: BodyPart.RIGHT_HIP, to: BodyPart.RIGHT_LEG_TRI),
//    (from: BodyPart.RIGHT_LEG_TRI, to: BodyPart.RIGHT_ANKLE),
//    (from: BodyPart.LEFT_SHOULDER, to: BodyPart.LEFT_BODY_CEN),
//    (from: BodyPart.LEFT_BODY_CEN, to: BodyPart.LEFT_HIP),
//    (from: BodyPart.RIGHT_SHOULDER, to: BodyPart.RIGHT_BODY_CEN),
//    (from: BodyPart.RIGHT_BODY_CEN, to: BodyPart.RIGHT_HIP),
  ]
    
    /// List of CAShapes filling the areas bounded by lines
    public static let shapes = [
        [1, 2, 7, 8],
//        [1, 2, 7],
//        [1, 18, 7],
//        [2, 17, 8],
//        [1, 2, 18, 17],
//        [18, 17, 7, 8],
        
        [1, 2, 3],
        [1, 2, 4],
        [1, 3, 5, 13],
        [2, 4, 6, 14],
        [7, 8, 9],
        [7, 8, 10],
        [7, 9, 11, 15],
        [8, 10, 12, 16]
    ]
}
