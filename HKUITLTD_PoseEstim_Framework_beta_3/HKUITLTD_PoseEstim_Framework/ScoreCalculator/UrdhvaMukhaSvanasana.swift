//
//  UrdhvaMukhaSvanasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 3/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class UrdhvaMukhaSvanasana: YogaBase{

    /** constant */
    private var arm_ratio: Double = 0.2
    private var shoulder_ratio: Double = 0.4
    private var hand_knee_foot_ratio: Double = 0.4

    /** score of body parts */

    private var arm_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    private var hand_knee_foot_score: Double = 0.0
    
    /** constructor */
    
    init(result: Result) {
        super.init()
        self.result = result
        self.resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** private method */
    private func makeComment(){
        comment = Array<String>()
        comment!.append("$arm_score, The Posture of the Arms " + FeedbackUtilities.comment(arm_score))
        comment!.append("$arm_score, The Posture of the Shoulder " + FeedbackUtilities.comment(shoulder_score))
        comment!.append("$arm_score, The Posture of the Arms " + FeedbackUtilities.comment(hand_knee_foot_score))

    }

    private func calculateScore(){
        

        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, true)
        arm_score = 0.5*(left_arm_score + right_arm_score)
        
        let left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 45.0, 10.0, true)
        let right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 45.0, 10.0, true)
        shoulder_score = 0.5*(left_shoulder_score + right_shoulder_score)
        
        let left_hand_knee_foot_angle = FeedbackUtilities.getAngle(resultArray![7], resultArray![5], resultArray![11])
        let left_hand_knee_foot_score = FeedbackUtilities.angleToScore(left_hand_knee_foot_angle, 180, 20, true)
        let right_hand_knee_foot_angle = FeedbackUtilities.getAngle(resultArray![8], resultArray![6], resultArray![12])
        let right_hand_knee_foot_score = FeedbackUtilities.angleToScore(left_hand_knee_foot_angle, 180, 20, true)
        hand_knee_foot_score = 0.5 * (left_hand_knee_foot_score + right_hand_knee_foot_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        let cb_ls:UInt = ColorFeedbackUtilities.left_shoulder(score: left_arm_score)
        let cb_rs:UInt = ColorFeedbackUtilities.right_shoulder(score: right_arm_score)
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_hand_knee_foot_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_hand_knee_foot_score)
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_hand_knee_foot_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_hand_knee_foot_score)
        
        let colorbitmerge: UInt = cb_la | cb_ra | cb_ls | cb_rs | cb_lw | cb_rw | cb_ll | cb_rl
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio*arm_score + shoulder_ratio*shoulder_score
        detailedscore = [arm_score, shoulder_score, hand_knee_foot_score]
        
    }

}
