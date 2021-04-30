//
//  RaiseLeftArm.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 27/4/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class RaiseLeftArm: YogaBase {

    /** constant */
    private let left_arm_ratio:Double = 0.4
    private let left_shoulder_ratio:Double = 0.4
    private let leg_ratio:Double = 0.2
    
    /** score of body parts */
    private var left_arm_score:Double = 0.0
    private var left_shoulder_score:Double = 0.0
    private var leg_score:Double = 0.0
    
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
        comment!.append("$left_arm_score, The Posture of the Left Arm " + FeedbackUtilities.comment(left_arm_score))
        comment!.append("$left_shoulder_score, The Posture of the Left Shoulder " + FeedbackUtilities.comment(left_shoulder_score))
        comment!.append("$leg_score, The Posture of the Legs " + FeedbackUtilities.comment(leg_score))
    }

    private func calculateScore(){
        
        let rshoulder_lankle_lhand_angle = FeedbackUtilities.getAngle(resultArray![3], resultArray![2],resultArray![5])
        let left_arm_score = FeedbackUtilities.angleToScore(rshoulder_lankle_lhand_angle, 90, 10, true)
        
//        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 90, 10, true)
        
        let left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 90, 10, true)
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 10.0, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 10.0, true)
        let leg_score = 0.5 * (left_leg_score + right_leg_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ls:UInt = ColorFeedbackUtilities.left_shoulder(score: left_shoulder_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
                
        let colorbitmerge: UInt = cb_la | cb_ls | cb_ll | cb_rl
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = left_arm_ratio * left_arm_score + left_shoulder_ratio * left_shoulder_score + leg_ratio * leg_score
        detailedscore = [left_arm_score, left_shoulder_score, leg_score]
    }
}
