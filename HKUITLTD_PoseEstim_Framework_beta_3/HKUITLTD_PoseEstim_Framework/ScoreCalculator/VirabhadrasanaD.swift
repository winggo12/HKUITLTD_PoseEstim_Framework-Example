//
//  VirabhadrasanaD.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation
import os
class VirabhadrasanaD: YogaBase {
    
    /** constant */
    private var leg_ratio: Double = 0.9
    private var shoulder_ratio: Double = 0.1

    /** score of body parts */
    private var shoulder_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var left_shoulder_score: Double = 0.0
    private var right_shoulder_score: Double = 0.0
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
        comment!.append("$shoulder_score, The Posture of the Arms " + FeedbackUtilities.comment(shoulder_score))
    }

    private func calculateScore(){
        
        if ( FeedbackUtilities.left_leg_angle(resultArray!) > FeedbackUtilities.right_leg_angle(resultArray!) )
        {
            left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20.0, true)
            right_leg_score = FeedbackUtilities.right_leg(resultArray!, 90.0, 20.0, true)
            
        }
        else
        {
            left_leg_score = FeedbackUtilities.left_leg(resultArray!, 90.0, 20.0, true)
            right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20.0, true)
        }
        
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 180.0, 20.0, true)
        right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 180.0, 20.0, true)
        shoulder_score = 0.5*(left_shoulder_score + right_shoulder_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_ls:UInt = ColorFeedbackUtilities.left_shoulder(score: left_shoulder_score)
        let cb_rs:UInt = ColorFeedbackUtilities.right_shoulder(score: right_shoulder_score)
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_ls | cb_rs
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = leg_ratio*leg_score + shoulder_ratio*shoulder_score
        detailedscore = [leg_score, shoulder_score]
        
    }

}

