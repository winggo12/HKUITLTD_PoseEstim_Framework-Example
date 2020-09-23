//
//  Navasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation

public class ArdhaUttanasana {
    
    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil
    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var leg_ratio: Double = 0.5
    private var hand_on_grd_ratio: Double = 0.5
//    private var waist_ratio: Double = 0.333

    /** score of body parts */
//    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var hand_on_grd_score: Double = 0.0

    /** constructor */
    init(result: Result) {
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** getter */
    func getScore()-> Double { return self.score! }
    func getComment()-> Array<String> { return self.comment! }
    func getResult()-> Result { return self.result! }
    func getDetailedScore()-> Array<Double>{return detailedscore!}
    /** private method */
    private func makeComment(){
        comment =  Array<String>()
        comment!.append("The Hand-to-Ground Distance " + utilities.comment(hand_on_grd_score))
        comment!.append("The angle between legs and floor " + utilities.comment(hand_on_grd_score))
//        comment!.append("The Waist-to-Thigh Distance " + utilities.comment(waist_score))
        comment!.append("The Straightness of the Legs " + utilities.comment(leg_score))

    }

    private func calculateScore(){

        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        if(left_leg_score > right_leg_score){
            leg_score = left_leg_score
        }else{
            leg_score = right_leg_score
        }

//        waist_score = utilities.right_waist(resultArray!, 90.0, 20.0, false)

        hand_on_grd_score = leg_floor_arm()
        score = leg_ratio * leg_score + hand_on_grd_ratio *  hand_on_grd_score
        detailedscore = [hand_on_grd_score, hand_on_grd_score, leg_score]

    }

    func hand_foot_horizontal()->  Double{
        let left_wrist = resultArray![5][1]
        let left_ankle = resultArray![11][1]
        let left_knee = resultArray![9][1]

        let hand_foot_distance = abs(left_wrist - left_ankle)
        let foot_knee_distance = abs(left_ankle - left_knee)

        let ratio = hand_foot_distance/foot_knee_distance

        if( ratio < 0.2){
            return 100.0
        }else if(ratio >= 0.2 && ratio < 0.5) {
            return 90.0
        }else if (ratio >= 0.5 && ratio < 0.8){
            return 80.0
        }else if (ratio >= 0.8 && ratio < 1.1){
            return 70.0
        }else{
            return 60.0
        }

    }
    
    private func leg_floor()-> Double{
        let left_knee = resultArray![9]
        let right_knee = resultArray![10]
        let left_ankle = resultArray![11]
        let right_ankle = resultArray![12]

        //draw a line parallel to screen's x-axis
        var left_floot_pt = Array<Double>(repeating: 0.0, count: 2)
        left_floot_pt[0] = resultArray![11][0] + 1
        left_floot_pt[1] = resultArray![11][1]
        var right_floot_pt = Array<Double>(repeating: 0.0, count: 2)
        right_floot_pt[0] = resultArray![12][0] + 1
        right_floot_pt[1] = resultArray![12][1]

        //find angle between leg and floor
        let left_angle = utilities.getAngle(left_ankle, left_knee, left_floot_pt)
        let right_angle = utilities.getAngle(right_ankle, right_knee, right_floot_pt)
        let left_leg_floor_score = utilities.angleToScore(left_angle, 90.0, 10.0, false)
        let right_leg_floor_score = utilities.angleToScore(right_angle, 90.0, 10.0, false)
        return 0.5 * (left_leg_floor_score + right_leg_floor_score)
    }
    
    private func leg_floor_arm()-> Double{
        let left_knee = resultArray![9]
        let right_knee = resultArray![10]
        let left_ankle = resultArray![11]
        let right_ankle = resultArray![12]
        let l_wrist = resultArray![5]
        let r_wrist = resultArray![6]


        //find angle between leg and floor
        let left_angle = utilities.getAngle(left_ankle, left_knee, l_wrist)
        let right_angle = utilities.getAngle(right_ankle, right_knee, r_wrist)
        let left_leg_floor_score = utilities.angleToScore(left_angle, 90.0, 10.0, true)
        let right_leg_floor_score = utilities.angleToScore(right_angle, 90.0, 10.0, true)
        return 0.5 * (left_leg_floor_score + right_leg_floor_score)
    }
}
