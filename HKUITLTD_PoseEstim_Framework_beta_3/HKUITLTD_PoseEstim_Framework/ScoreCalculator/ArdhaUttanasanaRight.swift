//
//  Navasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation

class ArdhaUttanasanaRight: YogaBase {

    /** constant */
    private let arm_ratio:Double = 0.1
    private let leg_ratio:Double = 0.1
    private let waist_ratio:Double = 0.4
    private let arm_leg_dis_ratio = 0.4

    /** constructor */
    init(result: Result) {
        super.init()
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }
    
    /** private method */
    private func makeComment(){
        comment =  Array<String>()
    }

    private func calculateScore(){
        
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180, 20, true)

        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 45, 10, true)
        
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20.0, true)
        
        let right_arm_length = FeedbackUtilities.cal_dis(coor1: resultArray![4], coor2: resultArray![6])
        let right_wrist_ankle_dis = FeedbackUtilities.cal_dis(coor1: resultArray![2], coor2: resultArray![12])
        let right_wrist_ankle_dis_score = FeedbackUtilities.disToScore(right_wrist_ankle_dis, 0.1 * right_arm_length, 0.2 * right_arm_length, true)
        
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        let cb_ral:UInt = ColorFeedbackUtilities.right_arm(score: right_wrist_ankle_dis_score)
        
        let colorbitmerge: UInt = cb_ra | cb_rw | cb_rl | cb_ral
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio * right_arm_score + waist_ratio * right_waist_score + leg_ratio * right_leg_score + arm_leg_dis_ratio * right_wrist_ankle_dis_score
        detailedscore = [right_arm_score, right_waist_score, right_leg_score, right_wrist_ankle_dis_score]
    }
}
