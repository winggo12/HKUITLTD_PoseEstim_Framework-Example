//
//  Natarajasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation

class Natarajasana{

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var leg_ratio = 0.3
    private var waist_ratio = 0.5
    private var arm_ratio = 0.2
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0

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
    private func makeComment(){
        comment =  Array<String>()
        comment!.append("The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("The Waist-to-Thigh Distance " + utilities.comment(waist_score))
        comment!.append("The Straightness of the Legs " + utilities.comment(leg_score))

    }

    private func calculateScore(){
        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, false)
        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, false)
        arm_score = (left_arm_score + right_arm_score) * 0.5

        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, false)
        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, false)
        if(right_leg_score > left_leg_score){
            leg_score = right_leg_score
        } else {
            leg_score = left_leg_score
        }
        //TO BE MODIFIED
        waist_score = utilities.right_waist(resultArray!, 90.0, 10.0, true) // 100

        score = arm_ratio * arm_score + leg_ratio * leg_score + waist_ratio * waist_score

    }

}
