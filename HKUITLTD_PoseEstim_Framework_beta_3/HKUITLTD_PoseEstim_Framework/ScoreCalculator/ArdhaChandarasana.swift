//
//  ArdhaChandarasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 19/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class ArdhaChandarasana {

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
    private var arm_ratio: Double = 0.2
    private var waist_ratio: Double = 0.4

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
    func getScore()-> Double { return self.score! }
    func getComment()-> Array<String> { return self.comment! }
    func getResult()-> Result { return self.result! }
    func getDetailedScore()-> Array<Double>{return detailedscore!}
    
    /** private method */
    private func makeComment(){
        comment =  Array<String>()
        comment!.append("$arm_score, The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("$waist_score, The Waist-to-Thigh Distance " + utilities.comment(waist_score))
        comment!.append("$leg_score, The Straightness of the Legs " + utilities.comment(leg_score))

    }

    private func calculateScore(){

        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, true)

        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)

        arm_score = 0.5 * (left_arm_score + right_arm_score)

        if(left_leg_score > right_leg_score){
            leg_score = left_leg_score
            
        }else {
            leg_score = right_leg_score
            
        }

        direction = decideDirection()
        switch(direction){
            case 5: waist_score = utilities.right_waist(resultArray!, 180.0, 20.0, true)
            default: waist_score = utilities.left_waist(resultArray!, 180.0, 20.0, true)
        }
        
        score = arm_ratio * arm_score + leg_ratio * leg_score + waist_ratio * waist_score
        detailedscore = [arm_score, waist_score, leg_score]

    }

    private func decideDirection()-> Int{
        let left_wrist = resultArray![5]
        let right_wrist = resultArray![6]
        if(left_wrist[1] > right_wrist[1]){
            return 5
        }else{
            return 6
        }
    }
}
