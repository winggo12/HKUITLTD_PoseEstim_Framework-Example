//
//  Tuladandasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class Tuladandasana {

    private let utilities: FeedbackUtilities = FeedbackUtilities()
    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private let leg_arm_waist_ratio = 0.7
    private let standing_leg_ratio = 0.3

    /** score of body parts */
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var standing_leg_score: Double = 0.0
    private var waist_score: Double = 0.0

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
    private func calculateScore(){
        let standing_leg: Int = self.standing_leg()
        leg_score = 0.0

        if(standing_leg == 11){
            standing_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
            leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        }else{
            standing_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
            leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        }

        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, true)
        arm_score = 0.5 * (left_arm_score + right_arm_score)

        waist_score = utilities.right_waist(resultArray!, 180.0, 20.0, true)
        let left_shoulder_score = utilities.left_shoulder(resultArray!, 180.0, 20.0, true)
        let right_shoulder_score = utilities.right_shoulder(resultArray!, 180.0, 20.0, true)
        let shoulder_score = 0.5 * (left_shoulder_score + right_shoulder_score)
        score = leg_arm_waist_ratio / 4 * (leg_score + arm_score + waist_score + shoulder_score) + standing_leg_ratio * standing_leg_score

    }

    private func makeComment(){

        comment =  Array<String>()
        comment!.append("The Straightness of the Arms" + utilities.comment( arm_score))
        comment!.append("The Straightness of the body " + utilities.comment( waist_score))
        comment!.append("The Straightness of the horizontal leg " + utilities.comment( leg_score))
        comment!.append("The Straightness of the standing leg " + utilities.comment( standing_leg_score))

    }

    private func standing_leg()-> Int{

        let left_ankle = resultArray![11]
        let r_ankle = resultArray![12]

        if(left_ankle[1] > r_ankle[1]){
            return 11
        }else{
            return 12
        }
    }
}
