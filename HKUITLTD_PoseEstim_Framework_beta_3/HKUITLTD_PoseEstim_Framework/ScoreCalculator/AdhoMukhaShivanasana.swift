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
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil
    /** constant */
    private let ratio = 1.0 / 3

    /** score of body parts */
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var shoulder_score: Double = 0.0
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
        comment!.append("$arm_score, The Curvature of the Waist " + utilities.comment(waist_score))
        comment!.append("$leg_score, The Distance between the Legs and the Hips " + utilities.comment(leg_score))

    }

    private func calculateScore(){
        
        let left_shoulder_score = utilities.left_shoulder(resultArray!, 180.0, 20.0, true)
        let right_shoulder_score = utilities.right_shoulder(resultArray!, 180.0, 20.0, true)
        shoulder_score = 0.5 * (left_shoulder_score + right_shoulder_score)
        
        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, true)

        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, true)
        arm_score = 0.5 * (left_arm_score + right_arm_score)

        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)

        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        leg_score = 0.5 * (left_leg_score + right_leg_score)
        
        let left_waist = utilities.left_waist(resultArray!, 90.0, 10.0, true)
        let right_waist = utilities.right_waist(resultArray!, 90.0, 10.0, true)
        waist_score = 0.5 * (left_waist + right_waist)
        score = ratio * (arm_score + leg_score + waist_score)
        detailedscore = [arm_score, waist_score, leg_score]
        
    }

}
