//
//  MarjarasanaC.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 3/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//猫式C
class MarjarasanaC: YogaBase{

    /** constant */
    private let shoulder_ratio:Double = 0.3
    private let waist_ratio:Double = 0.3
    private let knee_ratio:Double = 0.4

    /** score of body parts */
    private var shoulder_score:Double = 0.0
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
        
        let left_shoulder_score = FeedbackUtilities.left_shoulder_by_hsh(resultArray!, 90, 10, true)
        let right_shoulder_score = FeedbackUtilities.right_shoulder_by_hsh(resultArray!, 90, 10, true)
        shoulder_score = 0.5 * (left_shoulder_score + right_shoulder_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 90, 10, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 90, 10, true)
        waist_score = 0.5 * (left_waist_score + right_waist_score)
        
        let left_knee_score = FeedbackUtilities.left_leg(resultArray!, 90, 10, true)
        let right_knee_score = FeedbackUtilities.right_leg(resultArray!, 90, 10, true)
        knee_score = 0.5 * (left_knee_score + right_knee_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_knee_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_knee_score)

        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_shoulder_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_shoulder_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_lw | cb_rw
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = knee_ratio * knee_score + shoulder_ratio * shoulder_score + waist_ratio * waist_score
        detailedscore = [shoulder_score, waist_score, knee_score]
        
    }

}
