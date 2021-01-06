//
//  ArdhaVasisthasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class ArdhaVasisthasanaLeft: YogaBase{

    /** constant */
    private var waist_ratio: Double = 0.3
    private var l_hand_shoulder_r_hand_ratio: Double = 0.4
    private var l_shoulder_hand_foot_ratio: Double = 0.4

    /** score of body parts */
    private var waist_score: Double = 0.0
    private var l_hand_shoulder_r_hand_score: Double = 0.0
    private var l_shoulder_hand_foot_score: Double = 0.0

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
        comment!.append("$shoulder_score, The Angle of Leg,Arm and Shoulder  " + FeedbackUtilities.comment(l_shoulder_hand_foot_score))
        comment!.append("$arm_score, The Posture of Arm " + FeedbackUtilities.comment(l_hand_shoulder_r_hand_score))
    }

    private func calculateScore(){
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 180.0, 20.0, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 180.0, 20.0, true)
        waist_score = 0.5*(right_waist_score + left_waist_score)
        
        let l_hand_shoulder_r_hand_angle = FeedbackUtilities.getAngle(resultArray![1], resultArray![5], resultArray![6])
        l_hand_shoulder_r_hand_score = FeedbackUtilities.angleToScore(l_hand_shoulder_r_hand_angle, 180, 20, true)
        
        let l_shoulder_hand_foot_angle = FeedbackUtilities.getAngle(resultArray![5], resultArray![1], resultArray![11])
        l_shoulder_hand_foot_score = FeedbackUtilities.angleToScore(l_shoulder_hand_foot_angle, 90, 10, true)

        let cb_lh:UInt = ColorFeedbackUtilities.left_leg(score: l_hand_shoulder_r_hand_score)
        let cb_rh:UInt = ColorFeedbackUtilities.right_leg(score: l_hand_shoulder_r_hand_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)

        let colorbitmerge: UInt = cb_lh | cb_rh | cb_lw | cb_rw
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = waist_ratio*waist_score + l_shoulder_hand_foot_ratio*l_shoulder_hand_foot_score + l_hand_shoulder_r_hand_ratio*l_hand_shoulder_r_hand_score
        detailedscore = [waist_score, l_shoulder_hand_foot_score, l_hand_shoulder_r_hand_score]
        
    }

}
