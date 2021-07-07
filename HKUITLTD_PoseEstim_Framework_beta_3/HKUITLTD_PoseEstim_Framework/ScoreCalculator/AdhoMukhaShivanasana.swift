//
//  AdhoMukhaShivanasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 19/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class AdhoMukhaShivanasana: YogaBase {

    /** constant */
    private let ratio = 1.0 / 3
    private let arm_ratio = 0.1
    private let shoulder_ratio = 0.2
    private let waist_ratio = 0.6
    private let leg_ratio = 0.1
    /** score of body parts */
    private var arm_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0
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
        comment!.append("\(arm_score), The Straightness of the Arms " + FeedbackUtilities.comment(arm_score))
        comment!.append("\(waist_score), The Curvature of the Waist " + FeedbackUtilities.comment(waist_score))
        comment!.append("\(leg_score), The Distance between the Legs and the Hips " + FeedbackUtilities.comment(leg_score))

    }

    private func calculateScore(){
        
        let left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 180.0, 20.0, true)
        let right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 180.0, 20.0, true)
        shoulder_score = 0.5 * (left_shoulder_score + right_shoulder_score)
        
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, true)
        arm_score = 0.5 * (left_arm_score + right_arm_score)

        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20.0, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20.0, true)
        leg_score = 0.5 * (left_leg_score + right_leg_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 90.0, 10.0, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 90.0, 10.0, true)
        waist_score = 0.5 * (left_waist_score + right_waist_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_ls:UInt = ColorFeedbackUtilities.left_arm(score: left_shoulder_score)
        let cb_rs:UInt = ColorFeedbackUtilities.right_arm(score: right_shoulder_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_lw | cb_rw | cb_ls | cb_rs
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = ratio * (arm_score + leg_score + waist_score)
        detailedscore = [arm_score, waist_score, leg_score]
        
    }

}
