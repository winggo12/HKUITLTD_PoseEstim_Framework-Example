//
//  UtthitaPashvakonasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation
import os
class UtthitaPashvakonasanaB {

    private let utilities: FeedbackUtilities = FeedbackUtilities()
    private let colorutilities: ColorFeedbackUtilities = ColorFeedbackUtilities()
    
    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil
    private var colorbit: Array<Character>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var leg_ratio: Double = 0.4
    private var waist_ratio: Double = 0.4
    private var hand_ratio: Double = 0.2

    /** score of body parts */
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_score: Double = 0.0
    /** constructor */
    init(result: Result) {
        self.result = result
        self.resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** getter */
    func getScore()-> Double{ return score! }
    func getComment()-> Array<String>{return comment!}
    func getResult()-> Result{ return result!}
    func getDetailedScore()-> Array<Double>{return detailedscore!}
    func getColorBit()->Array<Character>{return colorbit!}

    /** private method */
    private func makeComment(){
        comment = Array<String>()
        comment!.append("$arm_score, The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("$waist_score, The Posture of the Waist " + utilities.comment(waist_score))


    }

    private func calculateScore(){

        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        let right_leg_score = utilities.right_leg(resultArray!, 90.0, 20.0, true)
        let leg_score = 0.5*(right_leg_score + left_leg_score)
        
        let left_waist_score = utilities.left_waist(resultArray!, 180.0, 10.0, true)
        let right_waist_score = utilities.right_waist(resultArray!, 180.0, 10.0, true)
        waist_score = 0.5 * (left_waist_score + right_waist_score)
        
        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 10.0, true)
        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 10.0, true)
        arm_score = 0.5 * (left_arm_score + right_arm_score)
        
        let cb_ll:UInt = colorutilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = colorutilities.right_leg(score: right_leg_score)
        
        let cb_la:UInt = colorutilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = colorutilities.right_arm(score: right_arm_score)
        
        let cb_lw:UInt = colorutilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = colorutilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_lw | cb_rw
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = arm_score + leg_score + waist_score
        detailedscore = [arm_score, waist_score, leg_score]
        

    }

}

