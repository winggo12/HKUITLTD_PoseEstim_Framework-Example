//
//  UtthitaParsvakonasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class UtthitaPashvakonasanaBLeft: YogaBase {

    /** constant */
    private let leg_angle_ratio = 0.4
    private let arm_leg_dis_ratio = 0.4
    private let leg_ratio = 0.1
    private let arm_ratio = 0.1
    
    /** scores*/
    private var right_arm_score:Double = 0.0
    private var right_leg_score:Double = 0.0
    private var leg_angle_score:Double = 0.0
    private var left_shoulder_knee_dis_score:Double = 0.0
    
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

        right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180, 2, true)
        
        right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180, 20, true)
        
        let leg_angle = FeedbackUtilities.getAngle(resultArray![8], resultArray![12], resultArray![9])
        leg_angle_score = FeedbackUtilities.angleToScore(leg_angle, 120, 10, true)
        
        let arm_length = FeedbackUtilities.cal_dis(coor1: resultArray![4], coor2: resultArray![6])
        let left_shoulder_knee_dis = FeedbackUtilities.cal_dis(coor1: resultArray![1], coor2: resultArray![9])
        left_shoulder_knee_dis_score = FeedbackUtilities.disToScore(left_shoulder_knee_dis, 0.1 * arm_length, 0.2 * arm_length, true)
        
        let cb_ra = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        let cb_rl = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        let cb_llangle = ColorFeedbackUtilities.left_leg(score: leg_angle_score)
        let cb_rlangle = ColorFeedbackUtilities.right_leg(score: leg_angle_score)
        let cb_ladis = ColorFeedbackUtilities.left_arm(score: left_shoulder_knee_dis_score)
        let cb_lldis = ColorFeedbackUtilities.left_leg(score: left_shoulder_knee_dis_score)
        
        colorbitmerge = cb_ra | cb_rl | cb_llangle | cb_rlangle | cb_ladis | cb_lldis

        score = arm_ratio*right_arm_score + leg_ratio*right_leg_score + leg_angle_ratio*leg_angle_score + arm_leg_dis_ratio*left_shoulder_knee_dis_score
        detailedscore = [right_arm_score, right_leg_score, leg_angle_score, left_shoulder_knee_dis_score]
    }

    private func makeComment(){
        comment = Array<String>()
        comment!.append("The Straightness of the Arms " + FeedbackUtilities.comment(right_arm_score))

    }
}
