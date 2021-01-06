//
//  Balasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

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
        
//        let leg_length = FeedbackUtilities.cal_dis(coor1: resultArray![7], coor2: resultArray![11])
        leg_score = 0.5 * (FeedbackUtilities.left_leg(resultArray!, 30, 10, true) + FeedbackUtilities.right_leg(resultArray!, 30, 10, true))
        waist_score = 0.5 * (FeedbackUtilities.left_waist(resultArray!, 30, 10, true) + FeedbackUtilities.right_waist(resultArray!, 30, 10, true))
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: leg_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_lw | cb_rw
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = 0.5*(waist_score+leg_score)
        detailedscore = [waist_score, leg_score]
        
    }
    
}
