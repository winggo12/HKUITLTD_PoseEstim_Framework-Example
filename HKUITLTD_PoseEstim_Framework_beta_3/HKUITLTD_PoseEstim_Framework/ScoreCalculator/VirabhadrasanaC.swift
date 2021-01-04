//
//  VirabhadrasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 1/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//


import Foundation
import os
class VirabhadrasanaC {

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
    private var leg_ratio: Double = 0.9
    private var waist_ratio: Double = 0.1

    /** score of body parts */
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var left_waist_score: Double = 0.0
    private var right_waist_score: Double = 0.0
    private var left_leg_score: Double = 0.0
    private var right_leg_score: Double = 0.0
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
        comment!.append("$waist_score, The Posture of the Waist " + utilities.comment(waist_score))
        comment!.append("$leg_score, The Posture of the Legs " + utilities.comment(leg_score))

    }

    private func calculateScore(){
        
        if  utilities.left_waist_angle(resultArray!) > utilities.right_waist_angle(resultArray!)
        {
            left_waist_score = utilities.left_waist(resultArray!, 180.0, 20.0, true)
            right_waist_score = utilities.right_waist(resultArray!, 90.0, 20.0, true)
            left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
            right_leg_score = utilities.right_leg(resultArray!, 90.0, 20.0, true)
            
        }
        else
        {
            left_waist_score = utilities.left_waist(resultArray!, 90.0, 20.0, true)
            right_waist_score = utilities.right_waist(resultArray!, 180.0, 20.0, true)
            left_leg_score = utilities.left_leg(resultArray!, 90.0, 20.0, true)
            right_leg_score = utilities.right_leg(resultArray!, 90.0, 20.0, true)
        }
        
        waist_score = 0.5 * (left_waist_score + right_waist_score)
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        let cb_ll:UInt = colorutilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = colorutilities.right_leg(score: right_leg_score)
        
        let cb_lw:UInt = colorutilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = colorutilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_lw | cb_rw
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = leg_ratio*leg_score + waist_ratio*waist_score
        detailedscore = [waist_score, leg_score]
        

    }

}

