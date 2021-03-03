//
//  Balasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//婴儿式
class Balasana: YogaBase{

    /** constant */
    private var waist_ratio: Double = 0.5
    private var leg_ratio: Double = 0.5

    /** score of body parts */
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
        comment!.append("$waist_score, Hip-Foot Distance  " + FeedbackUtilities.comment(leg_score))
        comment!.append("$leg_score, Chest-Knee Distance " + FeedbackUtilities.comment(waist_score))

    }


    private func calculateScore(){
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 30, 10, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 30, 10, true)
        leg_score = 0.5 * (left_leg_score + right_leg_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 30, 10, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 30, 10, true)
        waist_score = 0.5 * (left_waist_score + right_waist_score)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_lw | cb_rw
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = waist_ratio * waist_score + leg_ratio * leg_score
        detailedscore = [waist_score, leg_score]
        
    }
    
}
