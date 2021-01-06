//
//  Navasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation

class ArdhaUttanasanaLeft: YogaBase {

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
        
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180, 20, true)

        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 45, 10, true)

        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20.0, true)
       
        let left_arm_length = FeedbackUtilities.cal_dis(coor1: resultArray![1], coor2: resultArray![5])
        let left_wrist_ankle_dis = FeedbackUtilities.cal_dis(coor1: resultArray![1], coor2: resultArray![11])
        let left_wrist_ankle_dis_score = FeedbackUtilities.disToScore(left_wrist_ankle_dis, 0.5 * left_arm_length, 0.2 * left_arm_length, true)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)

        let cb_lal:UInt = ColorFeedbackUtilities.left_arm(score: left_wrist_ankle_dis_score)

        let colorbitmerge: UInt = cb_la | cb_lw | cb_ll | cb_lal
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio * left_arm_score + waist_ratio * left_waist_score + leg_ratio * left_leg_score + arm_leg_dis_ratio * left_wrist_ankle_dis_score
        detailedscore = [left_arm_score, left_waist_score, left_leg_score, left_wrist_ankle_dis_score]
    }
}
