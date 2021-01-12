//
//  UtthitaTrikonasana  .swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 31/12/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class UtthitaTrikonasanaLeft: YogaBase {

    /** constant */
    private let arm_leg_dis_ratio = 0.4
    private let waist_ratio = 0.4
    private let arm_ratio = 0.1
    private let leg_ratio = 0.1
    
    /** unit = ns */
    private var start_time: UInt64 = 0
    private var timer_ns: UInt64 = 0
    private var isStartTiming: Bool = false
    
    /** constructor */
    init(result: Result){
        super.init()
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }
    
    /** private method */
    private func calculateScore(){

        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, true)
        let arm_score =  0.5*( left_arm_score + right_arm_score )

        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 60.0, 10, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 120.0, 20, true)
        let waist_score = [left_waist_score, right_waist_score].min()
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20, true)
        let leg_score = 0.5*( left_leg_score + right_leg_score )
        
        let left_arm_length = FeedbackUtilities.cal_dis(coor1: resultArray![3], coor2: resultArray![5])
        let left_wrist_ankle_dis = FeedbackUtilities.cal_dis(coor1: resultArray![1], coor2: resultArray![11])
        let left_wrist_ankle_dis_score = FeedbackUtilities.disToScore(left_wrist_ankle_dis, 0.1 * left_arm_length, 0.2 * left_arm_length, true)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        let cb_lal:UInt = ColorFeedbackUtilities.left_arm(score: left_wrist_ankle_dis_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_lw | cb_rw | cb_lal

        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio * arm_score + waist_ratio * waist_score! + leg_ratio * leg_score + arm_leg_dis_ratio * left_wrist_ankle_dis_score
        detailedscore = [arm_score, waist_score!, leg_score, left_wrist_ankle_dis_score]
    }
    
    private func makeComment(){
        comment = Array<String>()

    }
    

}
