//
//  ArdhaPurvattanasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//半东方伸展式
class ArdhaPurvattanasana: YogaBase{

    /** constant */
    private var leg_ratio: Double = 0.3
    private var waist_ratio: Double = 0.4
    private var arm_ratio: Double = 0.3

    /** score of body parts */
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
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
        comment!.append("$arm_score, The Posture of the Arms " + FeedbackUtilities.comment(arm_score))
        comment!.append("$shoulder_score, The Posture of the Leg " + FeedbackUtilities.comment(leg_score))

    }

    private func calculateScore(){
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 90.0, 10, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 90.0, 10, true)
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 180.0, 10, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 180.0, 10, true)
        waist_score = 0.5*(left_waist_score + right_waist_score)
        
        let left_arm_score = FeedbackUtilities.left_shoulder_by_hsh(resultArray!, 90, 10, true)
        let right_arm_score = FeedbackUtilities.right_shoulder_by_hsh(resultArray!, 90, 10, true)
        arm_score = 0.5*(left_arm_score + right_arm_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let colorbitmerge: UInt =  cb_ll | cb_rl | cb_lw | cb_rw | cb_la | cb_ra
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = leg_ratio*leg_score + arm_ratio*arm_score + waist_ratio*waist_score
        detailedscore = [arm_score, waist_score, leg_score]
        
    }

}
