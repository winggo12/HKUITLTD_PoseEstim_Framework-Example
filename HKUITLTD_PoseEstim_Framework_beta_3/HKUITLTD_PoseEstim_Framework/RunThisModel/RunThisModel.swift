//
//  RunModel.swift
//  HKUITLTD_PoseEstim_Test
//
//  Created by hkuit155 on 29/6/2020.
//  Copyright © 2020 iosuser111. All rights reserved.
//

import Foundation
import UIKit
import os

public class RunthisModel{

    private var overlayviewframe: CGRect?
    private var previewviewframe: CGRect?
    private var modelAnalyzer: ModelAnalyzer?
    var threadCount: Int = Constants.defaultThreadCount
    var delegate: Delegates = Constants.defaultDelegate
    
    var overlayViewWidth: Float
    var overlayViewHeight: Float
    
    public init(){

            do {

          modelAnalyzer = try ModelAnalyzer(threadCount: threadCount, delegate: delegate)

        } catch let error {

          fatalError(error.localizedDescription)

        }

        os_log("Delegate is changed to: %s", delegate.description)

        os_log("Thread count is changed to: %d", threadCount)
        overlayViewWidth = 0
        overlayViewHeight = 0

    }

    

    public func Run(pb:CVPixelBuffer,olv:CGRect,pv:CGRect)-> (Result, Times)? {

        overlayviewframe = olv
        previewviewframe = pv
        let modelInputRange = overlayviewframe!.applying(
        previewviewframe!.size.transformKeepAspect(toFitIn: pb.size))
        overlayViewHeight = Float(olv.height)
        overlayViewWidth = Float(olv.width)
        // Run PoseNet model.
        guard
            let (result, times) = self.modelAnalyzer?.runPoseNet(
            on: pb,
            from: modelInputRange,
            to: overlayviewframe!.size)
        else {
          os_log("Cannot get inference result.", type: .error)
          return (DummyResult,DummyTime)
        }
        print("Times: ", times)
        return (result, times)
    }
}

