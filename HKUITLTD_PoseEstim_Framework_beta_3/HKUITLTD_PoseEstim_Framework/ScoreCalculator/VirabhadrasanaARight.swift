//
//  VirabhadrasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//


import Foundation

class VirabhadrasanaARight: YogaBase {

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
        
        arm_score = FeedbackUtilities.left_leg(resultArray!, 180, 20, true)
        
        waist_score = FeedbackUtilities.right_waist(resultArray!, 90, 10, true)
        
        knee_score = FeedbackUtilities.right_leg(resultArray!, 90, 10, true)
                
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: knee_score)
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: arm_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: waist_score)
        
        let colorbitmerge: UInt = cb_rl | cb_la | cb_rw
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio*arm_score + waist_ratio*waist_score + knee_ratio*knee_score
        detailedscore = [arm_score, waist_score, knee_score]
    }
}

