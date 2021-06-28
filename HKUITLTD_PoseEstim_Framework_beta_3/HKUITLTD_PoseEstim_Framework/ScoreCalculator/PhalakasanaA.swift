//
//  PhalakasanaA.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 6/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//侧板式A
class PhalakasanaA: YogaBase{

    /** constant */
    private var arm_ratio: Double = 0.3
    private var leg_ratio: Double = 0.3
//    private var waist_ratio: Double = 0.4
    private var arm_shoulder_foot_ratio: Double = 0.4
    
    /** score of body parts */
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
//    private var waist_score: Double = 0.0
    private var arm_shoulder_foot_score: Double = 0.0

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
        comment!.append("$arm_score, The Posture of the Arm " + FeedbackUtilities.comment(arm_shoulder_foot_score))
        comment!.append("$arm_score, The Posture of the arm " + FeedbackUtilities.comment(arm_score))
        comment!.append("$leg_score, The Posture of the Leg " + FeedbackUtilities.comment(leg_score))

    }

    private func calculateScore(){
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 10, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 10, true)
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        let left_arm_score = FeedbackUtilities.left_shoulder_by_hsh(resultArray!, 90, 10.0, true)
        let right_arm_score = FeedbackUtilities.right_shoulder_by_hsh(resultArray!, 90, 10.0, true)
        arm_score = 0.5*(left_arm_score + right_arm_score)
        
        let left_arm_shoulder_foot_angle = FeedbackUtilities.getAngle(resultArray![1], resultArray![5], resultArray![11])
        let left_arm_shoulder_foot_score = FeedbackUtilities.angleToScore(left_arm_shoulder_foot_angle, 90, 10, true)
        let right_arm_shoulder_foot_angle = FeedbackUtilities.getAngle(resultArray![2], resultArray![6], resultArray![12])
        let right_arm_shoulder_foot_score = FeedbackUtilities.angleToScore(right_arm_shoulder_foot_angle, 90, 10, true)
        arm_shoulder_foot_score = 0.5 * (left_arm_shoulder_foot_score + right_arm_shoulder_foot_score)
    
        let cb_la:UInt = ColorFeedbackUtilities.left_shoulder(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_shoulder(score: right_arm_score)
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
    
        let colorbitmerge: UInt = cb_la | cb_ra | cb_ll | cb_rl
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = arm_ratio * arm_score + leg_ratio * leg_score + arm_shoulder_foot_ratio * arm_shoulder_foot_score
        detailedscore = [arm_score, leg_score, arm_shoulder_foot_score]
        
    }

}
