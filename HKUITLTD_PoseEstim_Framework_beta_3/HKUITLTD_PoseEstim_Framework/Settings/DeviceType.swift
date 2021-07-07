//
//  DeviceType.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 24/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

public enum Delegates: Int, CaseIterable {
  case CPU
  case Metal

  public var description: String {
    switch self {
    case .CPU:
      return "CPU"
    case .Metal:
      return "GPU"
    }
  }
}
