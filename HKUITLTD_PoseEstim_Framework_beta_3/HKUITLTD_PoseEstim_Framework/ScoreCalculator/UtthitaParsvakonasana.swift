//
//  UtthitaParsvakonasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class UtthitaParsvakonasana {
    
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
    private let leg_ratio = 0.5
    private let arm_ratio = 0.1
    private let waist_ratio = 0.4

    /** score of body parts */
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var right_angle_leg_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    private var direction: Int = -1
    
    private var colorbitmerge: UInt = 0

    /** constructor */
    init(result: Result){
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** getter */
    func getScore()-> Double { return self.score! }
    func getComment()-> Array<String> { return self.comment! }
    func getResult()-> Result { return self.result! }
    func getDetailedScore()-> Array<Double>{return detailedscore!}
    func getColorBit()->Array<Character>{return colorbit!}
    
    /** private method */
    private func calculateScore(){

        direction = utilities.decideDirection(resultArray!)
        switch(direction){
            case 6:
                right_angle_leg_score = utilities.left_leg(resultArray!, 90.0, 20.0, false)
                leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, false)
                arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, false)
                shoulder_score = utilities.right_shoulder(resultArray!, 180.0, 20.0, false)
                waist_score =  utilities.right_waist(resultArray!, 180.0, 20.0, false)
            default:
                right_angle_leg_score = utilities.right_leg(resultArray!, 90.0, 20.0, false)
                leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, false)
                arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, false)
                shoulder_score = utilities.left_shoulder(resultArray!, 180.0, 20.0, false)
                waist_score =  utilities.left_waist(resultArray!, 180.0, 20.0, false)
        }
        
        if (direction == 6) {
            let cb_ll:UInt = colorutilities.left_leg(score: right_angle_leg_score)
            let cb_rl:UInt = colorutilities.right_leg(score: leg_score)
            let cb_a:UInt = colorutilities.right_arm(score: arm_score)
            let cb_s:UInt = colorutilities.right_shoulder(score: shoulder_score)
            let cb_w:UInt = colorutilities.right_waist(score: waist_score)
            colorbitmerge = cb_ll | cb_rl | cb_a | cb_s | cb_w
        }
        else {
            let cb_ll:UInt = colorutilities.left_leg(score: leg_score)
            let cb_rl:UInt = colorutilities.right_leg(score: right_angle_leg_score)
            let cb_a:UInt = colorutilities.left_arm(score: arm_score)
            let cb_s:UInt = colorutilities.left_shoulder(score: shoulder_score)
            let cb_w:UInt = colorutilities.left_waist(score: waist_score)
            colorbitmerge = cb_ll | cb_rl | cb_a | cb_s | cb_w
        }
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = arm_ratio / 2 * (leg_score + shoulder_score) + waist_ratio * waist_score + leg_ratio / 2 * (right_angle_leg_score + leg_score)
        detailedscore = [arm_score, waist_score, leg_score, right_angle_leg_score]
    }

    private func makeComment(){
        comment = Array<String>()
        
        var str: String
        var str1: String
        switch(direction){
            case 6:
                str = "right"
                str1 = "left"
            default:
                str = "left"
                str1 = "right"
        }
        comment!.append("The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("The Straightness from shoulder to knee " + utilities.comment(waist_score))
        comment!.append("The Straightness of the " + str + " leg " + utilities.comment(leg_score))
        comment!.append("The Curvature of the " + str1 + " leg " + utilities.comment(right_angle_leg_score))
    }



}
