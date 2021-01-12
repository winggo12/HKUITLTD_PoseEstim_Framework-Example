//
//  SetuBandhasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 5/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//桥式
class SetuBandhasana: YogaBase{
    
    /** constant */
    private var leg_ratio: Double = 0.3
    private var hand_foot_distance_ratio: Double = 0.3
    private var waist_ratio: Double = 0.4
    
    /** score of body parts */
    private var leg_score: Double = 0.0
    private var hand_foot_distance_score: Double = 0.0
    private var waist_score: Double = 0.0
    
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
        comment!.append("$waist_score, The Posture of the Waist " + FeedbackUtilities.comment(waist_score))
        comment!.append("$hand_foot_distance_score, Distance between Hand and Foot " + FeedbackUtilities.comment(hand_foot_distance_score))
        comment!.append("$leg_score, The Posture of the Leg " + FeedbackUtilities.comment(leg_score))

    }

    private func calculateScore(){
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 90.0, 20.0, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 90.0, 20.0, true)
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 150.0, 20.0, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 150.0, 20.0, true)
        waist_score = 0.5 * (left_waist_score + right_waist_score)
      
        let left_leg_length = FeedbackUtilities.cal_dis(coor1: resultArray![9], coor2: resultArray![11])
        let right_leg_length = FeedbackUtilities.cal_dis(coor1: resultArray![10], coor2: resultArray![12])
        let left_distance = FeedbackUtilities.cal_dis(coor1: resultArray![5], coor2: resultArray![11])
        let right_distance = FeedbackUtilities.cal_dis(coor1: resultArray![6], coor2: resultArray![12])
        let left_hand_foot_distance_score = FeedbackUtilities.disToScore(left_distance, left_leg_length*0.5, left_leg_length*0.2, true)
        let right_hand_foot_distance_score = FeedbackUtilities.disToScore(right_distance, right_leg_length*0.5, right_leg_length*0.2, true)
        hand_foot_distance_score = 0.5 * (left_hand_foot_distance_score + right_hand_foot_distance_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_hand_foot_distance_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_hand_foot_distance_score)
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let colorbitmerge: UInt =  cb_ll | cb_rl | cb_la | cb_ra
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = leg_ratio * leg_score + waist_ratio * waist_score + hand_foot_distance_ratio * hand_foot_distance_score
        detailedscore = [hand_foot_distance_score, waist_score, leg_score]
        
    }

}
