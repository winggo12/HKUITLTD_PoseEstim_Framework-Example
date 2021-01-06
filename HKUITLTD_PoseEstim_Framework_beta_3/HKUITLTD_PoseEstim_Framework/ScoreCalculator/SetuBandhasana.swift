//
//  SetuBandhasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 5/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class SetuBandhasana: YogaBase{
    
    /** constant */
    private var leg_ratio: Double = 0.3
    private var hand_foot_distance_ratio: Double = 0.3
    private var shoulder_elbow_foot_ratio: Double = 0.4
    
    /** score of body parts */

    
    private var leg_score: Double = 0.0
    private var hand_foot_distance_score: Double = 0.0
    private var shoulder_elbow_foot_score: Double = 0.0
    
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
        comment!.append("$shoulder_elbow_foot_score, The Distance between Shoulder,Elbow,Foot and Ground " + FeedbackUtilities.comment(shoulder_elbow_foot_score))
        comment!.append("$hand_foot_distance_score, Distance between Hand and Foot " + FeedbackUtilities.comment(hand_foot_distance_score))
        comment!.append("$leg_score, The Posture of the Leg " + FeedbackUtilities.comment(leg_score))

    }

    private func calculateScore(){
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 90.0, 10.0, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 90.0, 10.0, true)
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        let shoulder_elbow_foot_angle = 0.5 * ( FeedbackUtilities.getAngle(resultArray![3], resultArray![1], resultArray![11]) + FeedbackUtilities.getAngle(resultArray![4], resultArray![2], resultArray![12]) )
        shoulder_elbow_foot_score = FeedbackUtilities.angleToScore(shoulder_elbow_foot_angle, 180, 20, true)
        
        let foot_length = 0.5 * (FeedbackUtilities.cal_dis(coor1: resultArray![9], coor2: resultArray![11]) +  FeedbackUtilities.cal_dis(coor1: resultArray![10], coor2: resultArray![12]) )
        let distance = FeedbackUtilities.cal_dis(coor1: resultArray![5], coor2: resultArray![11]) + FeedbackUtilities.cal_dis(coor1: resultArray![6], coor2: resultArray![12])
        hand_foot_distance_score = FeedbackUtilities.disToScore(distance, foot_length*0.8, foot_length*0.2, true)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: hand_foot_distance_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: hand_foot_distance_score)
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        

        
        let colorbitmerge: UInt =  cb_ll | cb_rl | cb_la | cb_ra
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = leg_ratio*leg_score + shoulder_elbow_foot_ratio*shoulder_elbow_foot_score + hand_foot_distance_ratio*hand_foot_distance_score
        detailedscore = [leg_score, shoulder_elbow_foot_score, hand_foot_distance_score]
        
    }

}
