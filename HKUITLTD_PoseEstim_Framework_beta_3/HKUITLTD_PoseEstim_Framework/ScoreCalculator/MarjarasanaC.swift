//
//  MarjarasanaC.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 3/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

import Foundation
import os
class MarjarasanaC{

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var arm_ratio: Double = 0.1
    private var leg_ratio: Double = 0.1
    private var waist_ratio: Double = 0.8

    /** score of body parts */
    private var shoulder_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var left_arm_score: Double = 0.0
    private var right_arm_score: Double = 0.0
    private var left_waist_score: Double = 0.0
    private var right_waist_score: Double = 0.0
    private var left_leg_score: Double = 0.0
    private var right_leg_score: Double = 0.0
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
        comment!.append("$waist_score, The Posture of the Waist " + utilities.comment(waist_score))
        comment!.append("$arm_score, The Posture of the Arms " + utilities.comment(arm_score))
        comment!.append("$shoulder_score, The Posture of the Shoulder " + utilities.comment(arm_score))

    }

    private func calculateScore(){
        
        left_leg_score = utilities.left_leg(resultArray!, 90.0, 20.0, true)
        right_leg_score = utilities.right_leg(resultArray!, 90.0, 20.0, true)
        leg_score = 0.5*(right_leg_score + left_leg_score)
        
        left_arm_score = utilities.left_shoulder(resultArray!, 180.0, 20.0, true)
        right_arm_score = utilities.right_shoulder(resultArray!, 180.0, 20.0, true)
        arm_score = 0.5*(left_arm_score + right_arm_score)
        
        left_waist_score = utilities.left_waist(resultArray!, 90.0, 20.0, true)
        right_waist_score = utilities.right_waist(resultArray!, 90.0, 20.0, true)
        waist_score = 0.5*(left_waist_score + right_waist_score)
        
        score = leg_ratio*leg_score + arm_ratio*arm_score + waist_ratio*waist_score
        detailedscore = [leg_score, shoulder_score, waist_score]
        
    }

}
