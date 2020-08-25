//
//  ParivrttaTrikonasana.swift
//  PoseEstim
//
//  Created by iosuser111 on 9/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation
class ParivrttaTrikonasana {

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment : Array<String>? = nil
    private var score : Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private let leg_ratio = 0.4
    private let waist_ratio = 0.4
    private let arm_ratio = 0.2

    /** score of body parts */
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0

    private var direction: Int = -1
    /** constructor */
    init(result: Result){
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** getter */
    func getScore()-> Double {return self.score!}
    func getComment()-> Array<String> {return self.comment!}
    func getResult()-> Result {return self.result!}

    /** private method */
    private func calculateScore(){
        
        direction = utilities.decideDirection(resultArray!)

        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)

        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, true)

        if(left_leg_score > right_leg_score){
            leg_score = left_leg_score
        }else{
            leg_score = right_leg_score
        }
        arm_score = 0.5 * (left_arm_score + right_arm_score)
        let left_waist_score: Double
        let right_waist_score: Double
        
        switch(direction){
            case 5:
                left_waist_score = utilities.left_waist(resultArray!, 135.0, 20.0, true)
                right_waist_score = utilities.right_waist(resultArray!, 45.0, 20.0, true)
            default:
                left_waist_score = utilities.left_waist(resultArray!, 45, 20.0, true)
                right_waist_score = utilities.right_waist(resultArray!, 135.0, 20.0, true)
        }
        waist_score = 0.5 * (left_waist_score + right_waist_score)

        score = arm_ratio * arm_score +  leg_ratio * leg_score + waist_ratio * waist_score

    }

    private func makeComment(){

        comment =  Array<String>()
        comment!.append("The Straightness of the Arms " + utilities.comment( arm_score))
        comment!.append("The Waist-to-Thigh Distance " + utilities.comment( waist_score))
        comment!.append("The Straightness of the Legs " + utilities.comment( leg_score))


    }
    

}
