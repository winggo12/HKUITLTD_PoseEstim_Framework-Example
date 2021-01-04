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

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

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
        
        let left_waist = utilities.left_waist(resultArray!, 180.0, 10.0, true)
        let right_waist = utilities.right_waist(resultArray!, 180.0, 10.0, true)
        waist_score = 0.5 * (left_waist + right_waist)
        
        let left_arm = utilities.left_arm(resultArray!, 180.0, 10.0, true)
        let right_arm = utilities.right_arm(resultArray!, 180.0, 10.0, true)
        arm_score = 0.5 * (left_arm + right_arm)
        
        score = arm_score + leg_score + waist_score
        detailedscore = [arm_score, waist_score, leg_score]
        

    }

}

