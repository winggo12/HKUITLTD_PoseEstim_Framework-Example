//
//  ArdhaPurvattanasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class ArdhaPurvattanasana: YogaBase{

    /** constant */
    private var leg_ratio: Double = 0.2
    private var waist_ratio: Double = 0.4
    private var shoulder_ratio: Double = 0.2
    private var arm_ratio: Double = 0.2

    /** score of body parts */
    private var shoulder_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var left_shoulder_score: Double = 0.0
    private var right_shoulder_score: Double = 0.0
    private var left_arm_score: Double = 0.0
    private var right_arm_score: Double = 0.0
    private var left_waist_score: Double = 0.0
    private var right_waist_score: Double = 0.0
    private var left_leg_score: Double = 0.0
    private var right_leg_score: Double = 0.0
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
        
        left_leg_score = FeedbackUtilities.left_leg(resultArray!, 90.0, 10.0, true)
        right_leg_score = FeedbackUtilities.right_leg(resultArray!, 90.0, 10.0, true)
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        left_waist_score = FeedbackUtilities.left_waist(resultArray!, 180.0, 20.0, true)
        right_waist_score = FeedbackUtilities.right_waist(resultArray!, 180.0, 20.0, true)
        waist_score = 0.5*(left_waist_score + right_waist_score)
        
        left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 90.0, 10.0, true)
        right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 90.0, 10.0, true)
        shoulder_score = 0.5*(left_shoulder_score + right_shoulder_score)
        
        left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, true)
        right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, true)
        arm_score = 0.5*(left_arm_score + right_arm_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let cb_ls:UInt = ColorFeedbackUtilities.left_shoulder(score: left_shoulder_score)
        let cb_rs:UInt = ColorFeedbackUtilities.right_shoulder(score: right_shoulder_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let colorbitmerge: UInt =  cb_ll | cb_rl | cb_lw | cb_rw | cb_ls | cb_rs | cb_la | cb_ra
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = leg_ratio*leg_score + arm_ratio*arm_score + waist_ratio*waist_score + shoulder_ratio*shoulder_score
        detailedscore = [leg_score, waist_score, shoulder_score, arm_score]
        
    }

}
