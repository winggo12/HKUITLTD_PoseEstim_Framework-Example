//
//  Utkatasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 31/12/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//


import Foundation


class Utkatasana: YogaBase {

    /** constant */
    private let arm_ratio = 0.25
    private let shoulder_ratio = 0.25
    private let waist_ratio = 0.25
    private let leg_ratio = 0.25

    /** score of body parts */
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    
    /** constructor */
    init(result: Result){
        super.init()
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }
    
    /** private method */
    private func calculateScore(){
        
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, true)
        let arm_score =  0.5*( left_arm_score + right_arm_score )
        
        let left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 160.0, 20, true)
        let right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 160.0, 20, true)
        let shoulder_score = 0.5*( left_shoulder_score + right_shoulder_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 90.0, 10, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 90.0, 10, true)
        let waist_score = 0.5*( left_waist_score + right_shoulder_score)
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 90.0, 10, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 90.0, 10, true)
        let leg_score = 0.5*( left_leg_score + right_leg_score )
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_ls:UInt = ColorFeedbackUtilities.left_shoulder(score: left_shoulder_score)
        let cb_rs:UInt = ColorFeedbackUtilities.right_shoulder(score: right_shoulder_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_ls | cb_rs | cb_lw | cb_rw
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = arm_ratio * arm_score + shoulder_ratio * shoulder_score + waist_ratio * waist_ratio + leg_ratio * leg_score
        detailedscore = [arm_score,shoulder_score,waist_score,leg_score]
    }
    
    private func makeComment(){
        comment = Array<String>()
//        comment!.append("The Straightness of the Arms " + FeedbackUtilities.comment(body_score))
//        comment!.append("The time of standing: " + String(Double(timer_ns) / 1_000_000_000))
    }
}
