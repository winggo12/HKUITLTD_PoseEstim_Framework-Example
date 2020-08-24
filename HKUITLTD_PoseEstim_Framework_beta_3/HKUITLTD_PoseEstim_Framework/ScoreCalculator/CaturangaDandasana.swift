//
//  CaturangaDandasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation
class CaturangaDandasana{

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var leg_ratio: Double = 0.4
    private var arm_ratio: Double  = 0.3
    private var waist_ratio: Double  = 0.3
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
        comment!.append("$arm_score, The Curvature of the Arms " + utilities.comment(arm_score))
        comment!.append("The Waist-to-Thigh Distance " + utilities.comment(waist_score))
        comment!.append("The Straightness of the Legs " + utilities.comment(leg_score))

    }

    private func calculateScore(){
        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, false)
        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, false)
        if(right_leg_score > left_leg_score){
            leg_score = right_leg_score
        } else {
            leg_score = left_leg_score
            
        }

        let right_arm_score = utilities.right_arm(resultArray!, 90.0, 20.0, false)
        let left_arm_score = utilities.left_arm(resultArray!, 90.0, 20.0, false)
        if(right_arm_score > left_arm_score){
            arm_score = right_arm_score
        }else{
            arm_score = left_arm_score
        }

        waist_score = utilities.right_waist(resultArray!, 180.0, 20.0, false)
        score = arm_ratio * arm_score + leg_ratio * leg_score + waist_ratio * waist_score

    }


}
