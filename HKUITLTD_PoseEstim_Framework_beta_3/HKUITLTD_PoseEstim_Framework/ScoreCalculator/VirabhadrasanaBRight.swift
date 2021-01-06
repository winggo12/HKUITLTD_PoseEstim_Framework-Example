//
//  VirabhadrasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation
import os
class VirabhadrasanaBRight: YogaBase {

    /** constant */
    private let knee_ratio:Double = 0.4
    private let waist_ratio:Double = 0.4
    private let shoulder_ratio:Double = 0.2

    /** score of body parts */
    private var knee_score:Double = 0.0
    private var waist_score:Double = 0.0
    private var shoulder_score:Double = 0.0
    
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
        comment!.append("$shoulder_score, The Posture of the Arms " + FeedbackUtilities.comment(shoulder_score))
    }

    private func calculateScore(){
        
        let left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 90, 10, true)
        let right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 90, 10, true)
        shoulder_score = 0.5 * ( left_shoulder_score + right_shoulder_score )
        
        waist_score = FeedbackUtilities.right_waist(resultArray!, 90, 10, true)
        
        knee_score = FeedbackUtilities.right_leg(resultArray!, 90, 10, true)
                
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: knee_score)
        let cb_ls:UInt = ColorFeedbackUtilities.left_shoulder(score: left_shoulder_score)
        let cb_rs:UInt = ColorFeedbackUtilities.right_shoulder(score: right_shoulder_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: waist_score)
        
        let colorbitmerge: UInt = cb_rl | cb_ls | cb_rs | cb_rw
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = shoulder_ratio*shoulder_score + waist_ratio*waist_score + knee_ratio*knee_score
        detailedscore = [shoulder_score, waist_score, knee_score]
    }

}

