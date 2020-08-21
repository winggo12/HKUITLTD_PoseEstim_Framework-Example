//
//  UtthitaHastaPadangusthasanaA.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class UtthitaHastaPadangusthasanaA {
    
    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil


    /** constant */
    private let leg_ratio = 0.7
    private let waist_ratio = 0.2
    private let arm_ratio = 0.1

    /** score of body parts */
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0

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

    /** private method */
    private func calculateScore()->Double{
        arm_score = arm()
        leg_score = utilities.right_left_leg(resultArray!, 160.0, 20.0, true)
        waist_score = utilities.right_waist(resultArray!, 180.0, 20.0, false)

        score = leg_ratio * leg_score + waist_ratio * waist_score + arm_ratio * arm_score

        return score!
    }

    private func makeComment()->Array<String>{
        comment = Array<String>()
        comment!.append("The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("The Curvature of the Body " + utilities.comment(waist_score))
        comment!.append("The Curvature of the Legs " + utilities.comment(leg_score))

        return comment!
    }

    private func arm()-> Double {
        //TO BE MIDIFIED
        let r_wrist = resultArray![6]
        let r_ankle = resultArray![12]
        let l_wrist = resultArray![5]
        let l_ankle = resultArray![11]

        //if(abs(r_ankle[1] - r_wrist[1]) < MODEL_HEIGHT * 0.03 || abs(l_ankle[1] - l_wrist[1]) < MODEL_HEIGHT * 0.03){
        if(abs(r_ankle[1] - r_wrist[1]) < 100 * 0.03 || abs(l_ankle[1] - l_wrist[1]) < 100 * 0.03){
            return 100.0
        }else {
            return 90.0
        }

    }

}
