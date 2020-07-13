//
//  Navasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation

public class Navasana {
    
    var waist_ratio: Double
    var leg_ratio: Double
    var arm_ratio: Double
    var arm_score: Double
    var waist_score: Double
    var leg_score: Double
    var final_score: Double
    var result : Result
    var keypoints: Array<Array<Double>>

    public init(user_input_result :Result){

    self.waist_ratio = 0.33
    self.leg_ratio = 0.33
    self.arm_ratio = 0.33
    self.arm_score = 0
    self.waist_score = 0
    self.leg_score = 0
    self.final_score = 0
    self.result = user_input_result
    self.keypoints = ResultToArray(result: self.result)
    
    }
    
    public func vertical_waist(kps:Array<Array<Double>>) -> Double{
        let left_shoulder = kps[1]
        let left_hip = kps[7]
        let left_knee = kps[9]
        let angle = get_angle(center_coord: left_hip, coord1: left_shoulder, coord2: left_knee)
        if abs(angle - 90) < 5{
            return 100
        }

        if abs(angle - 90) < 15 && abs(angle - 90) >= 5{
            return 90
        }

        if abs(angle - 90) < 25 && abs(angle - 90) >= 15{
            return 80
        }

        if abs(angle - 90) < 35 && abs(angle - 90) >= 25{
            return 70
        }

        else{
            return 60
        }
    }
    
    public func straight_right_arm(kps:Array<Array<Double>>)->Double{

        let r_elbow = kps[4]
        let r_shoulder = kps[2]
        let r_wrist = kps[6]
        let arm_angle = get_angle(center_coord: r_elbow, coord1: r_shoulder, coord2: r_wrist)
        
        if arm_angle > 170{
            return 100
        }
        
        if arm_angle > 150{
            return 90
        }
        
        if arm_angle > 130{
            return 80
        }
        
        if arm_angle > 110{
            return 70
        }
            
        else{
            return 60
        }
    }
    
    public func straight_left_arm(kps:Array<Array<Double>>)->Double{
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

        if arm_angle > 130{
            return 80
        }

        if arm_angle > 110{
            return 70
        }

        else{
            return 60
        }
    }
    

    public func straight_leg(kps:Array<Array<Double>>)->Double{
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
    
    public func get_score() -> Double{
        self.keypoints = ResultToArray(result: self.result)
        self.arm_score = self.arm_ratio * Double(0.5*(straight_left_arm(kps: self.keypoints) + straight_right_arm(kps: self.keypoints)))
        self.waist_score = self.waist_ratio * Double(vertical_waist(kps:self.keypoints))
        self.leg_score = self.leg_ratio * Double(straight_leg(kps: self.keypoints))
        self.final_score = arm_score + waist_score + leg_score
        return self.final_score
    }
    
    public func get_recommendation()-> [String] {
        var c : [String] = []

        var arm_score : Double = ((straight_left_arm(kps:self.keypoints)) + (straight_right_arm(kps:self.keypoints)))/2
        
        var c1 = "The Straightness of the Arms " + comment(score: arm_score)
        
        var c2 =  "The Waist-to-Thigh Distance " + comment(score: vertical_waist(kps:self.keypoints))
        
        var c3 = "The Straightness of the Legs " + comment(score: straight_leg(kps:self.keypoints))

        c+=[c1,c2,c3]
        
        return c
    }
}
