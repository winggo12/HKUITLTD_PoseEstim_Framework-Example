//
//  CalAngle.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 26/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

public func get_angle(center_coord: Array<Double>, coord1: Array<Double>, coord2: Array<Double>) -> Double{

    let center_dis = cal_dis(coor1: coord1, coor2: coord2)
    let dis1 = cal_dis(coor1: center_coord, coor2: coord2)
    let dis2 = cal_dis(coor1: center_coord, coor2: coord1)
    let angle = cal_angle(length_center: center_dis, length1: dis1, length2: dis2)

    return angle

}


public func cal_angle(length_center: Double, length1: Double, length2: Double) -> Double{
    let out = (pow(length1, 2) + pow(length2, 2) - pow(length_center, 2))/(2 * length1 * length2)
    do{
        let result = acos(out) * (180/Double.pi)
        return result
    }
    catch{
        let result = 180.0
        return result
    }
}



public func cal_dis(coor1: Array<Double>, coor2: Array<Double>) -> Double {

    let out = pow(coor1[0]-coor2[0],2) + pow(coor1[1]-coor2[1],2)
    return sqrt(out)

}
