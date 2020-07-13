//
//  UrdhvaDhanurasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation

func ud_straight_arm(kps:Array<Array<Double>>)->Double{

    let left_elbow = kps[3]

    let left_shoulder = kps[1]

    let left_wrist = kps[5]

    let arm_angle = get_angle(center_coord: left_elbow, coord1: left_shoulder, coord2: left_wrist)

    if arm_angle > 170{

        return 100

    }

    if arm_angle > 150{

        return 90

    }

    if arm_angle > 120{

        return 80

    }

    if arm_angle > 90{

        return 70

    }

    else{

        return 60

    }

}



func ud_straight_leg(kps:Array<Array<Double>>)->Double{

    let left_knee = kps[9]

    let left_hip = kps[7]

    let left_ankle = kps[11]

    let leg_angle = get_angle(center_coord: left_knee, coord1: left_ankle, coord2: left_hip)

    if leg_angle > 170{

        return 100

    }



    if leg_angle > 150{

        return 90

    }



    if leg_angle>120{

        return 80

    }

    if leg_angle > 90{

        return 70

    }

    else{

        return 60

    }

}



func ud_straight_waist(kps:Array<Array<Double>>) -> Double {

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

func get_urdhva_dhanurasana_score(kps:Array<Array<Double>>) -> Double{
    
    let leg_ratio = 0.3

    let waist_ratio = 0.4

    let arm_ratio = 0.3

    let arm_score = arm_ratio * Double(ud_straight_arm(kps:kps))

    let leg_score = leg_ratio * Double(ud_straight_leg(kps:kps))

    let dis_score = waist_ratio * Double(ud_straight_waist(kps:kps))

    return arm_score + leg_score + dis_score

}
