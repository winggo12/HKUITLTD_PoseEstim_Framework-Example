//
//  VirabhadrasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//


import Foundation

//战士式A
class VirabhadrasanaA: YogaBase {

    /** constant */
    private let knee_ratio:Double = 0.4
    private let waist_ratio:Double = 0.4
    private let arm_ratio:Double = 0.2
    
    /** score of body parts */
    private var arm_score:Double = 0.0
    private var waist_score:Double = 0.0
    private var knee_score:Double = 0.0
    
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
    }

    private func calculateScore(){
        
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180, 20, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180, 20, true)
        arm_score = 0.5 * (left_arm_score + right_arm_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 90, 20, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 90, 20, true)
        waist_score = max(left_waist_score, right_waist_score)
        
        let left_knee_score = FeedbackUtilities.left_leg(resultArray!, 90, 20, true)
        let right_knee_score = FeedbackUtilities.right_leg(resultArray!, 90, 20, true)
        knee_score = max(left_knee_score, right_knee_score)
        
        let cb_l:UInt
        if left_knee_score > right_knee_score {
            cb_l = ColorFeedbackUtilities.left_leg(score: knee_score)
        }else {
            cb_l = ColorFeedbackUtilities.right_leg(score: knee_score)
        }
        
        let cb_w:UInt
        if left_waist_score > right_waist_score {
            cb_w = ColorFeedbackUtilities.left_waist(score: waist_score)
        }else {
            cb_w = ColorFeedbackUtilities.right_waist(score: waist_score)
        }
        
        let cb_la:UInt = ColorFeedbackUtilities.right_arm(score: arm_score)
        
        let colorbitmerge: UInt = cb_l | cb_la | cb_w
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio*arm_score + waist_ratio*waist_score + knee_ratio*knee_score
        detailedscore = [waist_score, knee_score, arm_score]
    }
}

