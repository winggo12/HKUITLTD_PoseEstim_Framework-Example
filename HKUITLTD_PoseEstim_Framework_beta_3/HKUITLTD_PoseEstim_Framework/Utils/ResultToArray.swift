//
//  ResultToArray.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 26/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

public func ResultToArray(result:Result)->Array<Array<Double>>{
var kps: Array<Array<Double>> = [[0,0],[1,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],[8,8],[9,9],[10,10],[11,11],[12,12]]

for i in 0...12 {
    kps[i][0] = Double(result.dots[i].x)
    kps[i][1] = Double(result.dots[i].y)
}
    return kps
    
}
