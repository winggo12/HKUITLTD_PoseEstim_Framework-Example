//
//  VirabhadrasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//


import Foundation

//战士式C
class VirabhadrasanaC: YogaBase {

    /** constant */
    private let knee_ratio:Double = 0.4
    private let waist_ratio:Double = 0.4
    private let leg_ratio:Double = 0.2
    
    /** score of body parts */
    private var knee_score:Double = 0.0
    private var waist_score:Double = 0.0
    private var leg_score:Double = 0.0
    
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
        comment!.append("$leg_score, The Posture of the Legs " + FeedbackUtilities.comment(leg_score))
    }

    private func calculateScore(){
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 90, 20, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 90, 20, true)
        waist_score = max(left_waist_score, right_waist_score)
        
        var left_knee_score = FeedbackUtilities.left_leg(resultArray!, 90, 20, true)
        var right_knee_score = FeedbackUtilities.right_leg(resultArray!, 90, 20, true)
        knee_score = max(left_knee_score, right_knee_score)
        
        if left_knee_score > right_knee_score {
            right_knee_score = FeedbackUtilities.right_leg(resultArray!, 180, 20, true)
            leg_score = right_knee_score
        }else {
            left_knee_score = FeedbackUtilities.left_leg(resultArray!, 180, 20, true)
            leg_score = left_knee_score
        }
                
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_knee_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_knee_score)
        
        let cb_w:UInt
        if left_waist_score > right_waist_score {
            cb_w = ColorFeedbackUtilities.left_waist(score: waist_score)
        }else {
            cb_w = ColorFeedbackUtilities.right_waist(score: waist_score)
        }
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_w
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = leg_ratio*leg_score + waist_ratio*waist_score + knee_ratio*knee_score
        detailedscore = [waist_score, knee_score, leg_score]
    }
}

