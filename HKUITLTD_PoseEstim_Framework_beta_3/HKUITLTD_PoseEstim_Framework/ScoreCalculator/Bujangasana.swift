//
//  Bujangasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 3/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class Bujangasana: YogaBase{

    /** constant */
    private var arm_ratio: Double = 0.3
    private var waist_ratio: Double = 0.7

    /** score of body parts */
    private var shoulder_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_score: Double = 0.0
    
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

    }

    private func calculateScore(){
        

        left_arm_score = FeedbackUtilities.left_shoulder(resultArray!, 90.0, 20.0, true)
        right_arm_score = FeedbackUtilities.right_shoulder(resultArray!, 90.0, 20.0, true)
        arm_score = 0.5*(left_arm_score + right_arm_score)
        
        left_waist_score = FeedbackUtilities.left_waist(resultArray!, 100.0, 20.0, true)
        right_waist_score = FeedbackUtilities.right_waist(resultArray!, 100.0, 20.0, true)
        waist_score = 0.5*(left_waist_score + right_waist_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_la | cb_ra | cb_lw | cb_rw
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = arm_ratio*arm_score + waist_ratio*waist_score
        detailedscore = [arm_score, waist_score]
        
    }

}
