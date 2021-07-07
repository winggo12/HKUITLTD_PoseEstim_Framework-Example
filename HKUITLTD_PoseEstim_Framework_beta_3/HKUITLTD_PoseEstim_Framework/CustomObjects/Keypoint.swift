//
//  Keypoint.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 24/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation
import UIKit

public struct KeyPoint {
  public var bodyPart: BodyPart = BodyPart.HEAD
  public var position: CGPoint = CGPoint()
  public var score: Float = 0.0
}
