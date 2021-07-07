//
//  UrdhvaDhanurasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation

class UrdhvaDhanurasana: YogaBase {
    
    /** constant */
    private var arm_ratio: Double = 0.3
    private var hand_foot_distance_ratio: Double = 0.3
    private var shoulder_hand_foot_ratio: Double = 0.4
    
    /** score of body parts */

    
    private var arm_score: Double = 0.0
    private var hand_foot_distance_score: Double = 0.0
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
        comment!.append("$shoulder_hand_foot_score, The Angle between Shoulder,Hand,Foot  " + FeedbackUtilities.comment(shoulder_hand_foot_score))
        comment!.append("$hand_foot_distance_score, Distance between Hand and Foot " + FeedbackUtilities.comment(hand_foot_distance_score))
        comment!.append("$arm_score, The Posture of the Leg " + FeedbackUtilities.comment(arm_score))

    }

    private func calculateScore(){
        
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 90.0, 10.0, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 90.0, 10.0, true)
        arm_score = 0.5*(left_arm_score + right_arm_score)
        
        let shoulder_hand_foot_angle = 0.5 * ( FeedbackUtilities.getAngle(resultArray![5], resultArray![1], resultArray![11]) + FeedbackUtilities.getAngle(resultArray![6], resultArray![2], resultArray![12]) )
        shoulder_hand_foot_score = FeedbackUtilities.angleToScore(shoulder_hand_foot_angle, 180, 20, true)
        
        let hand_length = 0.5 * (FeedbackUtilities.cal_dis(coor1: resultArray![9], coor2: resultArray![11]) +  FeedbackUtilities.cal_dis(coor1: resultArray![10], coor2: resultArray![12]) )
        let distance = 0.5 * (FeedbackUtilities.cal_dis(coor1: resultArray![5], coor2: resultArray![11]) + FeedbackUtilities.cal_dis(coor1: resultArray![6], coor2: resultArray![12]) )
        hand_foot_distance_score = FeedbackUtilities.disToScore(distance, hand_length*0.8, hand_length*0.2, true)
        

        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        //Distance between Hand and Foot : For Hand
        let cb_lhd:UInt = ColorFeedbackUtilities.left_leg(score: hand_foot_distance_score)
        let cb_rhd:UInt = ColorFeedbackUtilities.right_leg(score: hand_foot_distance_score)
        
        //Distance between Hand and Foot : For Foot
        let cb_lfd:UInt = ColorFeedbackUtilities.left_leg(score: hand_foot_distance_score)
        let cb_rfd:UInt = ColorFeedbackUtilities.right_leg(score: hand_foot_distance_score)
        
        let colorbitmerge: UInt =  cb_la | cb_ra | cb_lhd | cb_rhd | cb_lfd | cb_rfd
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = arm_ratio*arm_score + hand_foot_distance_ratio*hand_foot_distance_score + hand_foot_distance_ratio*hand_foot_distance_score
        detailedscore = [arm_score, hand_foot_distance_score, hand_foot_distance_score]
        
    }

}

