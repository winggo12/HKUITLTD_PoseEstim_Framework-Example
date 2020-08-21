//
//  UtthitaHastaPadangusthasanaC.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class UtthitaHastaPadangusthasanaC {

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private let leg_ratio = 0.6
    private let waist_ratio = 0.4

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

        let leg_score = right_left_leg()

        let waist_score = utilities.left_waist(resultArray!, 180.0, 20.0, false)

        score = leg_ratio * leg_score + waist_ratio * waist_score

        return score!
    }

    private func makeComment()->Array<String>{
        comment = Array<String>()
        comment!.append("The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("The Curvature of the Body " + utilities.comment(waist_score))
        comment!.append("The Curvature of the Legs " + utilities.comment(leg_score))

        return comment!
    }

    func right_left_leg()-> Double{
        let left_hip = resultArray![7]
        let left_knee = resultArray![9]
        let right_hip = resultArray![8]
        let right_knee = resultArray![10]

        /** move line between right_hip and right_knee to make the above two lines intersect */
        let diffX = left_hip[0] - right_hip[0]
        let diffY = left_hip[1] - right_hip[1]
        let movedLine = utilities.moveLine(right_hip, right_knee, diffX, diffY)
        let new_right_hip = movedLine[0]
        let new_right_knee = movedLine[1]

        let angle = utilities.getAngle(new_right_hip, new_right_knee, left_knee)

        return angleToScore(angle)
    }
    private func angleToScore(_ angle:Double)-> Double{
        if(angle >= 90  && angle <= 120)  {
            return 100.0
        } else if(angle >= 70 ) {
            return 90.0
        } else if(angle >= 50)  {
            return 80.0
        } else if(angle >= 30)  {
            return 70.0
        } else{
            return 60.0
        }
    }
}
