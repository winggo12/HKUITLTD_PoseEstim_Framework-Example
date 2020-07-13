//
//  Navasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation

public class ArdhaUttanasana {
    
    var hand_ratio: Double
    var leg_ratio: Double
    var waist_ratio: Double
    var waist_score: Double
    var hand_score: Double
    var leg_score: Double
    var final_score: Double
    var result : Result
    var keypoints: Array<Array<Double>>

    public init(user_input_result :Result){

    self.hand_ratio = 0.333
    self.leg_ratio = 0.333
    self.waist_ratio = 0.333
    self.waist_score = 0
    self.hand_score = 0
    self.leg_score = 0
    self.final_score = 0
    self.result = user_input_result
    self.keypoints = ResultToArray(result: self.result)
    
    }
    
    public func vertical_waist(kps:Array<Array<Double>>) -> Double{
        let left_shoulder = kps[2]
        let left_hip = kps[8]
        let left_knee = kps[10]
        let angle = get_angle(center_coord: left_hip, coord1: left_shoulder, coord2: left_knee)
        if angle < 90{
            return 100
        }
        if angle >= 90 && angle <= 110 {
            return 90
        }
        if angle >= 110 && angle < 130 {
            return 80
        }
        if angle >= 130 && angle < 150 {
            return 70
        }
        else{
            return 60
        }
    }
    
    public func hand_distance(kps:Array<Array<Double>>)->Double{
        let left_wrist = kps[5][1]
        let left_ankle = kps[11][1]
        let left_knee = kps[9][1]
        
        let hand_foot_distance = abs(left_wrist - left_ankle)
        let foot_knee_distance = abs(left_ankle - left_knee)
        
        let ratio = hand_foot_distance/foot_knee_distance

        if ratio < 0.2{
            return 100
        }
        if ratio >= 0.2 && ratio < 0.5{
            return 90
        }
        if ratio >= 0.5 && ratio < 0.8{
            return 80
        }
        if ratio >= 0.8 && ratio < 1.1{
            return 70
        }
        else{
            return 60
        }
    }
    
    public func straight_right_leg(kps:Array<Array<Double>>)->Double{
        let right_knee = kps[10]
        let right_hip = kps[8]
        let right_ankle = kps[12]
        let leg_angle = get_angle(center_coord: right_knee, coord1: right_ankle, coord2: right_hip)
        
        if leg_angle >= 90{
            return 100
        }
        if leg_angle >= 80 && leg_angle < 90 {
            return 90
        }
        if leg_angle >= 70 && leg_angle < 80{
            return 80
        }
        if leg_angle >= 60 && leg_angle < 70{
            return 70
        }
        else{
            return 60
        }
    }

    public func straight_left_leg(kps:Array<Array<Double>>)->Double{
        let left_knee = kps[9]
        let left_hip = kps[7]
        let left_ankle = kps[11]
        let leg_angle = get_angle(center_coord: left_knee, coord1: left_ankle, coord2: left_hip)
        if leg_angle >= 90{
            return 100
        }
        if leg_angle >= 80 && leg_angle < 90 {
            return 90
        }
        if leg_angle >= 70 && leg_angle < 80{
            return 80
        }
        if leg_angle >= 60 && leg_angle < 70{
            return 70
        }
        else{
            return 60
        }
    }
    
    
    public func get_score() -> Double{
        self.keypoints = ResultToArray(result: self.result)
        let left_leg_score = straight_left_leg(kps:self.keypoints)
        let right_leg_score = straight_right_leg(kps: self.keypoints)
        self.leg_score = leg_ratio * Double(left_leg_score > right_leg_score ? left_leg_score : right_leg_score)
        
        self.waist_score = self.waist_ratio * Double(vertical_waist(kps:self.keypoints))
        self.hand_score = self.hand_ratio * Double(hand_distance(kps:self.keypoints))
        self.final_score = hand_score + waist_score + leg_score
        return self.final_score
    }
    
    public func get_recommendation()-> [String] {
        var c : [String] = []
        
        var leg_score : Double = ((straight_left_leg(kps:self.keypoints)) + (straight_right_leg(kps:self.keypoints)))/2
        

        var c1 =  "Hands-to-Ground's Distance " + comment(score: hand_distance(kps:self.keypoints))
        
        var c2 = "The Waist-to-Thigh's Angle " + comment(score: vertical_waist(kps:self.keypoints))
        
        var c3 =  "The Straightness of the Legs " + comment(score: leg_score)

        c += [c1,c2,c3]
        
        return c
    }
}
