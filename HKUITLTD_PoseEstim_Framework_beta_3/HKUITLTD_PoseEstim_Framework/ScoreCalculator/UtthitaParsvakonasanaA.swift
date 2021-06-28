//
//  UtthitaParsvakonasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//侧角伸展式A
class UtthitaParsvakonasanaA: YogaBase {

    /** constant */
    private let arm_leg_dis_ratio = 0.4
    private let leg_ratio = 0.3
    private let arm_ratio = 0.3
    
    /** scores*/
    private var arm_score:Double = 0.0
    private var leg_score:Double = 0.0
    private var elbow_knee_dis_score:Double = 0.0
    
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

        let left_arm_score = FeedbackUtilities.left_shoulder_by_hsh(resultArray!, 150, 20, true)
        let right_arm_score = FeedbackUtilities.right_shoulder_by_hsh(resultArray!, 150, 20, true)
        arm_score = max(left_arm_score, right_arm_score)
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180, 10, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180, 10, true)
        leg_score = max(left_leg_score, right_leg_score)
    
        let right_leg_length = FeedbackUtilities.cal_dis(coor1: resultArray![12], coor2: resultArray![8])
        let left_elbow_knee_dis = FeedbackUtilities.cal_dis(coor1: resultArray![3], coor2: resultArray![9])
        let left_elbow_knee_dis_score = FeedbackUtilities.disToScore(left_elbow_knee_dis, 0.2 * right_leg_length, 0.2 * right_leg_length, true)
        let left_leg_length = FeedbackUtilities.cal_dis(coor1: resultArray![11], coor2: resultArray![7])
        let right_elbow_knee_dis = FeedbackUtilities.cal_dis(coor1: resultArray![4], coor2: resultArray![10])
        let right_elbow_knee_dis_score = FeedbackUtilities.disToScore(right_elbow_knee_dis, 0.2 * left_leg_length, 0.2 * left_leg_length, true)
        elbow_knee_dis_score = max(left_elbow_knee_dis_score, right_elbow_knee_dis_score)
        
        let cb_a:UInt
        if left_arm_score > right_arm_score {
            cb_a = ColorFeedbackUtilities.left_arm(score: arm_score)
        }else {
            cb_a = ColorFeedbackUtilities.right_arm(score: arm_score)
        }
        
        let cb_l:UInt
        if left_leg_score > right_leg_score {
            cb_l = ColorFeedbackUtilities.left_leg(score: leg_score)
        }else {
            cb_l = ColorFeedbackUtilities.right_leg(score: leg_score)
        }

        let cb_adis:UInt
        let cb_ldis:UInt
        if left_elbow_knee_dis_score > right_elbow_knee_dis_score {
            cb_adis = ColorFeedbackUtilities.left_arm(score: elbow_knee_dis_score)
            cb_ldis = ColorFeedbackUtilities.left_leg(score: elbow_knee_dis_score)
        }else {
            cb_adis = ColorFeedbackUtilities.right_arm(score: elbow_knee_dis_score)
            cb_ldis = ColorFeedbackUtilities.right_leg(score: elbow_knee_dis_score)
        }
        
        colorbitmerge = cb_a | cb_l | cb_adis | cb_ldis
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio * arm_score + leg_ratio * leg_score + arm_leg_dis_ratio * elbow_knee_dis_score
        detailedscore = [arm_score, leg_score, elbow_knee_dis_score]
    }

    private func makeComment(){
        comment = Array<String>()
        comment!.append("The Straightness of the Arms " + FeedbackUtilities.comment(arm_score))

    }
}
