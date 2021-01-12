//
//  Navasana.swift
//  PoseEstim
//
//  Created by hkuit155 on 2/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//
import Foundation


//船式
class Navasana: YogaBase {

    /** constant */
    private let waist_ratio: Double = 0.6
    private let leg_ratio: Double = 0.2
    private let arm_ratio: Double = 0.2

    /** score of body parts */
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0

    /** constructor */
    init(result: Result){
        super.init()
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** private method */
    private func calculateScore(){
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, true)
        arm_score = (left_arm_score + right_arm_score) * 0.5

        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 90.0, 20.0, false)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 90.0, 20.0, false)
        waist_score = 0.5 * (left_waist_score + right_waist_score)

        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20.0, true)
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20.0, true)
        leg_score = 0.5 * (right_leg_score + left_leg_score)

        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_rw
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = arm_ratio * arm_score + waist_ratio * waist_score + leg_ratio * leg_score
        detailedscore = [arm_score, waist_score, leg_score]
    }


    private func makeComment(){

        comment =  Array<String>()
        comment!.append("The Straightness of the Arms " + FeedbackUtilities.comment( arm_score))
        comment!.append("The Waist-to-Thigh Distance " + FeedbackUtilities.comment( waist_score))
        comment!.append("The Straightness of the Legs " + FeedbackUtilities.comment( leg_score))

    }
}

