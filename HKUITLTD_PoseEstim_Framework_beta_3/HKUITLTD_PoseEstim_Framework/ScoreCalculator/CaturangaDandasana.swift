//
//  CaturangaDandasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation

func cd_straight_leg(kps:Array<Array<Double>>) -> Double{
    let left_elbow = kps[3]
    let left_shoulder = kps[1]
    let left_wrist = kps[5]
    let leg_angle = get_angle(center_coord: left_elbow, coord1: left_shoulder, coord2: left_wrist)
    if leg_angle > 170{
        return 100
    }
    if leg_angle > 150{
        return 90
    }
    if leg_angle > 130{
        return 80
    }
    if leg_angle > 110{
        return 70
    }
    else{
        return 60
    }
}


func cd_arm_angle(kps:Array<Array<Double>>) -> Double{
    let left_elbow = kps[3]
    let left_shoulder = kps[1]
    let left_wrist = kps[5]
    let arm_angle = get_angle(center_coord: left_elbow, coord1: left_shoulder, coord2: left_wrist)
    if abs(arm_angle - 90) < 5{
        return 100
    }
    if abs(arm_angle - 90) < 15 && abs(arm_angle - 90) >= 5{
        return 90
    }
    if abs(arm_angle - 90) < 25 && abs(arm_angle - 90) >= 15{
        return 80
    }
    if abs(arm_angle - 90) < 35 && abs(arm_angle - 90) >= 25{
        return 70
    }
    else{
        return 60
    }
}

func cd_straight_waist(kps:Array<Array<Double>>) -> Double {
    let left_shoulder = kps[2]
    let left_hip = kps[8]
    let left_knee = kps[10]
    let angle = get_angle(center_coord: left_hip, coord1: left_shoulder, coord2: left_knee)
    if angle < 100{
        return 100
    }
    if angle >= 100 && angle < 120 {
        return 90
    }
    if angle >= 120 && angle < 140 {
        return 80
    }
    if angle >= 140 && angle < 160 {
        return 70
    }
    else{
        return 60
    }
}


func get_caturanga_dandasana_score(kps:Array<Array<Double>>) -> Double{
    
    let leg_ratio = 0.4
    let arm_ratio = 0.3
    let waist_ratio = 0.3
    let leg_score = leg_ratio * Double(cd_straight_leg(kps:kps))
    let arm_score = arm_ratio * Double(cd_arm_angle(kps:kps))
    let waist_score = waist_ratio * Double(cd_straight_waist(kps:kps))
    return arm_score + leg_score + waist_score

}
