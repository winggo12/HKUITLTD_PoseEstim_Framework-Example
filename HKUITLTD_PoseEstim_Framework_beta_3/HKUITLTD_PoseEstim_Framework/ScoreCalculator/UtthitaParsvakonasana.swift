//
//  UtthitaParsvakonasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class UtthitaParsvakonasana: YogaBase {

    /** constant */
    private let leg_ratio = 0.5
    private let arm_ratio = 0.1
    private let waist_ratio = 0.4

    /** score of body parts */
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var right_angle_leg_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    private var direction: Int = -1
    
    private var colorbitmerge: UInt = 0

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

        direction = FeedbackUtilities.decideDirection(resultArray!)
        switch(direction){
            case 6:
                right_angle_leg_score = FeedbackUtilities.left_leg(resultArray!, 90.0, 20.0, false)
                leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20.0, false)
                arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, false)
                shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 180.0, 20.0, false)
                waist_score =  FeedbackUtilities.right_waist(resultArray!, 180.0, 20.0, false)
            default:
                right_angle_leg_score = FeedbackUtilities.right_leg(resultArray!, 90.0, 20.0, false)
                leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20.0, false)
                arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, false)
                shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 180.0, 20.0, false)
                waist_score =  FeedbackUtilities.left_waist(resultArray!, 180.0, 20.0, false)
        }
        
        if (direction == 6) {
            let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: right_angle_leg_score)
            let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: leg_score)
            let cb_a:UInt = ColorFeedbackUtilities.right_arm(score: arm_score)
            let cb_s:UInt = ColorFeedbackUtilities.right_shoulder(score: shoulder_score)
            let cb_w:UInt = ColorFeedbackUtilities.right_waist(score: waist_score)
            colorbitmerge = cb_ll | cb_rl | cb_a | cb_s | cb_w
        }
        else {
            let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: leg_score)
            let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_angle_leg_score)
            let cb_a:UInt = ColorFeedbackUtilities.left_arm(score: arm_score)
            let cb_s:UInt = ColorFeedbackUtilities.left_shoulder(score: shoulder_score)
            let cb_w:UInt = ColorFeedbackUtilities.left_waist(score: waist_score)
            colorbitmerge = cb_ll | cb_rl | cb_a | cb_s | cb_w
        }
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = arm_ratio / 2 * (leg_score + shoulder_score) + waist_ratio * waist_score + leg_ratio / 2 * (right_angle_leg_score + leg_score)
        detailedscore = [arm_score, waist_score, leg_score, right_angle_leg_score]
    }

    private func makeComment(){
        comment = Array<String>()
        
        var str: String
        var str1: String
        switch(direction){
            case 6:
                str = "right"
                str1 = "left"
            default:
                str = "left"
                str1 = "right"
        }
        comment!.append("The Straightness of the Arms " + FeedbackUtilities.comment(arm_score))
        comment!.append("The Straightness from shoulder to knee " + FeedbackUtilities.comment(waist_score))
        comment!.append("The Straightness of the " + str + " leg " + FeedbackUtilities.comment(leg_score))
        comment!.append("The Curvature of the " + str1 + " leg " + FeedbackUtilities.comment(right_angle_leg_score))
    }
}
