//
//  ArdhaVasisthasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//半瓦希斯塔式
class ArdhaVasisthasana: YogaBase{

    /** constant */
    private let arm_ratio:Double = 0.3
    private var waist_ratio: Double = 0.3
    private var shoulder_hand_foot_ratio: Double = 0.4

    /** score of body parts */
    private var arm_score:Double = 0.0
    private var waist_score: Double = 0.0
    private var shoulder_hand_foot_score: Double = 0.0
    
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
        comment!.append("$waist_score, Thw Posture of Waist  " + FeedbackUtilities.comment(waist_score))
        comment!.append("$shoulder_score, The Angle of Leg,Arm and Shoulder  " + FeedbackUtilities.comment(shoulder_hand_foot_score))
        comment!.append("$arm_score, The Posture of Arm " + FeedbackUtilities.comment(arm_score))
    }

    private func calculateScore(){
        
        let left_arm_score = FeedbackUtilities.left_shoulder_by_hsh(resultArray!, 110, 20, true)
        let right_arm_score = FeedbackUtilities.right_shoulder_by_hsh(resultArray!, 110, 20, true)
        arm_score = 0.5 * (left_arm_score + right_arm_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 180.0, 10, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 180.0, 10, true)
        waist_score = 0.5*(right_waist_score + left_waist_score)
        
        
        let l_shoulder_hand_foot_angle = FeedbackUtilities.getAngle(resultArray![5], resultArray![1], resultArray![11])
        let l_shoulder_hand_foot_score = FeedbackUtilities.angleToScore(l_shoulder_hand_foot_angle, 90, 10, true)
        let r_shoulder_hand_foot_angle = FeedbackUtilities.getAngle(resultArray![6], resultArray![2], resultArray![12])
        let r_shoulder_hand_foot_score = FeedbackUtilities.angleToScore(r_shoulder_hand_foot_angle, 90, 10, true)
        shoulder_hand_foot_score = max(l_shoulder_hand_foot_score, r_shoulder_hand_foot_score)

        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)

        let colorbitmerge: UInt = cb_la | cb_ra | cb_lw | cb_rw
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = waist_ratio * waist_score + shoulder_hand_foot_ratio * shoulder_hand_foot_score + arm_ratio * arm_score
        detailedscore = [waist_score, arm_score, shoulder_hand_foot_score]
        
    }

}
