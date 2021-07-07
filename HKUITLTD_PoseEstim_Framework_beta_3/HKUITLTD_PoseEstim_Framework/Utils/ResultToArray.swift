//
//  ResultToArray.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 26/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

public func ResultToArray(result:Result)->Array<Array<Double>>{
var kps: Array<Array<Double>> = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]

    for i in 0...(tfModel.output.keypointSize-1) {
    kps[i][0] = Double(result.dots[i].x)
    kps[i][1] = Double(result.dots[i].y)
}
    return kps
    
}

extension Result{
    public func classToArray()->Array<Array<Double>>{
        var returnArray: Array<Array<Double>> = [[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0],[0,0]]
        for i in 0...(tfModel.output.keypointSize-1) {
            returnArray[i][0] = Double(self.dots[i].x)
            returnArray[i][1] = Double(self.dots[i].y)
        }
        return returnArray
    }
}
