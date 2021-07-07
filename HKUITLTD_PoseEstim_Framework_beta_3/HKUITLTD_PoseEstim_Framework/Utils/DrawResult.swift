//
//  DrawResult.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 3/7/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

func drawResult(of result: Result, on overlayView: OverlayView) {
  overlayView.dots = result.dots
  overlayView.lines = result.lines
  overlayView.setNeedsDisplay()
}

func clearResult(on overlayView: OverlayView) {
  overlayView.clear()
  overlayView.setNeedsDisplay()
}
