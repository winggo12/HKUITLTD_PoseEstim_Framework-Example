//
//  Bujangasana.swift
//  PoseEstim
//
//  Created by iosuser111 on 5/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation
func get_bujangasana_score(kps:Array<Array<Double>>) -> Double{

    func straight_arm(kps:Array<Array<Double>>)->Int{

        let left_elbow = kps[3]

        let left_shoulder = kps[1]

        let left_wrist = kps[5]

        let arm_angle = get_angle(center_coord: left_elbow, coord1: left_shoulder, coord2: left_wrist)

        if arm_angle > 70{

            return 100

        }

        if arm_angle > 50{

            return 90

        }

        if arm_angle > 30{

            return 80

        }

        if arm_angle > 10{

            return 70

        }

        else{

            return 60

        }

    }

    func straight_waist(kps:Array<Array<Double>>) -> Int {

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

    let waist_ratio = 0.7

    let arm_ratio = 0.3



    let arm_score = arm_ratio * Double(straight_arm(kps:kps))

    let dis_score = waist_ratio * Double(straight_waist(kps:kps))

    return arm_score + dis_score

}
