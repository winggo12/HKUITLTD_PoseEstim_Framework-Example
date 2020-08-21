//
//  Bujangasana.swift
//  PoseEstim
//
//  Created by iosuser111 on 5/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation

class Bujangasana {

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private let waist_ratio = 0.7
    private let arm_ratio = 0.3

    /** score of body parts */
    private var arm_score = -1.0
    private var waist_score = -1.0

    private var l_arm_angle = 0.0
    private var r_arm_angle = 0.0
    private var waist_angle = 0.0
    
    /** constructor */
    init(result: Result) {
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
    private func makeComment()-> Array<String>{
        comment = Array<String>(arrayLiteral:
            "l_arm_angle: $l_arm_angle, r_arm_angle: $r_arm_angle, score: $arm_score, Arms " + utilities.comment(arm_score),
            "waist_angle: $waist_angle, $waist_score, Waist" + utilities.comment(waist_score))
        return comment!
    }

    private func calculateScore()-> Double{
        let l_arm_score = utilities.left_arm(resultArray!, 90.0, 20.0, true)
        let r_arm_score = utilities.right_arm(resultArray!, 90.0, 20.0, true)
        arm_score = 0.5 * (l_arm_score + r_arm_score)
        waist_score = utilities.right_waist(resultArray!,120.0, 20.0, true)

        score = arm_ratio * arm_score + waist_ratio *  waist_score

        return score!
    }


}
