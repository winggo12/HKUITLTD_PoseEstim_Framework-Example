//
//  Vrkshasana.swift
//  PoseEstim
//
//  Created by iosuser111 on 5/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation

//func get_vrkshasana_score(kps:Array<Array<Double>>)->Double{
//    
//    func leg(kps:Array<Array<Double>>)->Int{
//        let left_hip = kps[8]
//        let left_knee = kps[10]
//        let right_hip = kps[9]
//        let right_knee = kps[11]
//        //TO BE MODIFIED
//        let arm_angle = get_angle(center_coord: left_elbow, coord1: left_shoulder, coord2: left_wrist)
//
//        if arm_angle > 170{
//
//            return 100
//
//        }
//
//        if arm_angle > 150{
//
//            return 90
//
//        }
//
//        if arm_angle > 120{
//
//            return 80
//
//        }
//
//        if arm_angle > 90{
//
//            return 70
//
//        }
//
//        else{
//
//            return 60
//
//        }
//
//    }
//
//    
//    let leg_ratio = 0.3
//
//    let waist_ratio = 0.4
//
//    let arm_ratio = 0.3
//
//
//
//    let arm_score = arm_ratio * Double(ud_straight_arm(kps:kps))
//
//    let leg_score = leg_ratio * Double(ud_straight_leg(kps:kps))
//
//    let dis_score = waist_ratio * Double(ud_straight_waist(kps:kps))
//
//    return arm_score + leg_score + dis_score
//}
//
