//
//  Navasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation

//半加强站立前弯式
class ArdhaUttanasana: YogaBase {

    /** constant */
    private let arm_ratio:Double = 0.3
    private let leg_ratio:Double = 0.3
    private let waist_ratio:Double = 0.4
//    private let arm_leg_dis_ratio = 0.4

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
        
        let left_arm_score = FeedbackUtilities.left_shoulder_by_hsh(resultArray!, 90, 10, true)
        let right_arm_score = FeedbackUtilities.right_shoulder_by_hsh(resultArray!, 90, 10, true)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 45, 10, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 45, 10, true)
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 10, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 10, true)
       
//        let left_arm_length = FeedbackUtilities.cal_dis(coor1: resultArray![1], coor2: resultArray![5])
//        let left_wrist_ankle_dis = FeedbackUtilities.cal_dis(coor1: resultArray![1], coor2: resultArray![11])
//        let left_wrist_ankle_dis_score = FeedbackUtilities.disToScore(left_wrist_ankle_dis, 0.5 * left_arm_length, 0.2 * left_arm_length, true)
//        let right_arm_length = FeedbackUtilities.cal_dis(coor1: resultArray![2], coor2: resultArray![6])
//        let right_wrist_ankle_dis = FeedbackUtilities.cal_dis(coor1: resultArray![2], coor2: resultArray![12])
//        let right_wrist_ankle_dis_score = FeedbackUtilities.disToScore(right_wrist_ankle_dis, 0.5 * right_arm_length, 0.2 * right_arm_length, true)
        
        let arm_score = 0.5 * (left_arm_score + right_arm_score)
        let waist_score = 0.5 * (left_waist_score + right_waist_score)
        let leg_score = 0.5 * (left_leg_score + right_leg_score)
//        let wrist_ankle_dis_score = 0.5 * (left_wrist_ankle_dis_score + right_wrist_ankle_dis_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
//        let cb_lal:UInt = ColorFeedbackUtilities.left_arm(score: left_wrist_ankle_dis_score)
//        let cb_ral:UInt = ColorFeedbackUtilities.right_arm(score: right_wrist_ankle_dis_score)

//        let colorbitmerge: UInt = cb_la | cb_ra | cb_lw | cb_rw | cb_ll | cb_rl | cb_lal | cb_ral
//
//        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
//        score = arm_ratio * arm_score + waist_ratio * waist_score + leg_ratio * leg_score + arm_leg_dis_ratio * wrist_ankle_dis_score
//        detailedscore = [arm_score, waist_score, leg_score, wrist_ankle_dis_score]
        
        let colorbitmerge: UInt = cb_la | cb_ra | cb_lw | cb_rw | cb_ll | cb_rl
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio * arm_score + waist_ratio * waist_score + leg_ratio * leg_score
        detailedscore = [arm_score, waist_score, leg_score]
    }
}
