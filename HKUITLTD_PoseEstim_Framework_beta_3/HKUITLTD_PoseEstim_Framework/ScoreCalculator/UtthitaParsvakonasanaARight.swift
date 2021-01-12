//
//  UtthitaParsvakonasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class UtthitaParsvakonasanaARight: YogaBase {

    /** constant */
    private let arm_leg_dis_ratio = 0.4
    private let leg_ratio = 0.3
    private let arm_ratio = 0.3
    
    /** scores*/
    private var left_arm_score:Double = 0.0
    private var left_leg_score:Double = 0.0
    private var right_elbow_knee_dis_score:Double = 0.0
    
    private var colorbitmerge: UInt = 0

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

        left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180, 20, true)
        
        left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180, 20, true)
        
        let leg_length = FeedbackUtilities.cal_dis(coor1: resultArray![11], coor2: resultArray![7])
        let right_elbow_knee_dis = FeedbackUtilities.cal_dis(coor1: resultArray![4], coor2: resultArray![10])
        right_elbow_knee_dis_score = FeedbackUtilities.disToScore(right_elbow_knee_dis, 0.5 * leg_length, 0.2 * leg_length, true)
        
        let cb_la = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ll = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_radis = ColorFeedbackUtilities.right_arm(score: right_elbow_knee_dis_score)
        let cb_rldis = ColorFeedbackUtilities.right_leg(score: right_elbow_knee_dis_score)
        
        colorbitmerge = cb_la | cb_ll | cb_radis | cb_rldis
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio * left_arm_score + leg_ratio * left_leg_score +  arm_leg_dis_ratio * right_elbow_knee_dis_score
        detailedscore = [left_arm_score, left_leg_score, right_elbow_knee_dis_score]
    }

    private func makeComment(){
        comment = Array<String>()
        comment!.append("The Straightness of the Arms " + FeedbackUtilities.comment(left_arm_score))
    }
}
