//
//  AdhoMukhaShivanasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 19/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class AdhoMukhaShivanasana {
    private let utilities: FeedbackUtilities = FeedbackUtilities()
    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil
    /** constant */
    private let ratio = 0.25

    /** score of body parts */
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0

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

    /** private method */
    private func makeComment()-> Array<String>{
        comment = Array<String>()
        comment!.append("$arm_score, The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("$leg_score, The Straightness of the Legs " + utilities.comment(leg_score))
        return comment!
    }

    private func calculateScore()-> Double{

        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, false)

        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, false)
        arm_score = ratio * 2 * (left_arm_score + right_arm_score)

        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, false)

        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, false)
        leg_score = ratio * 2 * (left_leg_score + right_leg_score)

        score = ratio * (left_arm_score + right_arm_score + left_leg_score + right_leg_score)
        return score!
    }

}
