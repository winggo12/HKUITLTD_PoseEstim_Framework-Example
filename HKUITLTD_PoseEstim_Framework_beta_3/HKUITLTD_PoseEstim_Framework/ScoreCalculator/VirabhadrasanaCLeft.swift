//
//  VirabhadrasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//


import Foundation

class VirabhadrasanaCLeft: YogaBase {

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
                
        waist_score = FeedbackUtilities.left_waist(resultArray!, 90, 10, true)
        
        knee_score = FeedbackUtilities.left_leg(resultArray!, 90, 10, true)
        
        leg_score = FeedbackUtilities.right_leg(resultArray!, 180, 20, true)
                
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: knee_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: leg_score)
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_lw
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = leg_ratio*leg_score + waist_ratio*waist_score + knee_ratio*knee_score
        detailedscore = [waist_score, knee_score, leg_score]
    }
}

