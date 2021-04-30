//
//  RaiseRightArm.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 27/4/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class RaiseRightArm: YogaBase {

    /** constant */
    private let right_arm_ratio:Double = 0.4
    private let right_shoulder_ratio:Double = 0.4
    private let leg_ratio:Double = 0.2
    
    /** score of body parts */
    private var right_arm_score:Double = 0.0
    private var right_shoulder_score:Double = 0.0
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
        comment!.append("$right_arm_score, The Posture of the Left Arm " + FeedbackUtilities.comment(right_arm_score))
        comment!.append("$right_shoulder_score, The Posture of the Left Shoulder " + FeedbackUtilities.comment(right_shoulder_score))
        comment!.append("$leg_score, The Posture of the Legs " + FeedbackUtilities.comment(leg_score))
    }

    private func calculateScore(){

        let lshoulder_rankle_rhand_angle = FeedbackUtilities.getAngle(resultArray![4], resultArray![1],resultArray![6])
        let right_arm_score = FeedbackUtilities.angleToScore(lshoulder_rankle_rhand_angle, 90, 10, true)
                
//        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 90, 10, true)

        let right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 90, 10, true)
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 10.0, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 10.0, true)
        let leg_score = 0.5 * (left_leg_score + right_leg_score)
        
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        let cb_rs:UInt = ColorFeedbackUtilities.right_shoulder(score: right_shoulder_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
                
        let colorbitmerge: UInt = cb_ra | cb_rs | cb_ll | cb_rl
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = right_arm_ratio * right_arm_score + right_shoulder_ratio * right_shoulder_score + leg_ratio * leg_score
        detailedscore = [right_arm_score, right_shoulder_score, leg_score]
    }
}
