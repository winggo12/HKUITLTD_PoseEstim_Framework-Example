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

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var leg_ratio: Double = 0.333
    private var hand_on_grd_ratio: Double = 0.333
    private var waist_ratio: Double = 0.333

    /** score of body parts */
    private var waist_score: Double = 0.0
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

    /** private method */
    private func makeComment()-> Array<String>{
        comment =  Array<String>()
        comment!.append("$hand_on_grd_score, The Hand-to-Ground Distance " + utilities.comment(hand_on_grd_score))
        comment!.append("$waist_score, The Waist-to-Thigh Distance " + utilities.comment(waist_score))
        comment!.append("$leg_score, The Straightness of the Legs " + utilities.comment(leg_score))
        return comment!
    }

    private func calculateScore()->Double{

        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        if(left_leg_score > right_leg_score){
            leg_score = left_leg_score
        }else{
            leg_score = right_leg_score
        }

        waist_score = utilities.right_waist(resultArray!, 90.0, 20.0, false)

        hand_on_grd_score = hand_foot_horizontal()

        score = leg_ratio * leg_score + waist_ratio * waist_score + hand_on_grd_ratio *  hand_on_grd_score
        return score!
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
}
