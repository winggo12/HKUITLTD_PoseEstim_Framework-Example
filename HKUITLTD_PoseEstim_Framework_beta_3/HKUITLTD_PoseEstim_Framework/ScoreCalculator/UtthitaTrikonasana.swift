//
//  UtthitaTrikonasana  .swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 31/12/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class UtthitaTrikonasana: YogaBase {

    /** constant */
    private let leg_ratio = 0.4
    private let waist_ratio = 0.4
    private let arm_ratio = 0.2

    /** score of body parts */
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    
    private var left_waist_score: Double = 0.0
    private var right_waist_score: Double = 0.0
    
    /** unit = ns */
    private var start_time: UInt64 = 0
    private var timer_ns: UInt64 = 0
    private var isStartTiming: Bool = false
    
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
        let arm_score =  0.5*( left_arm_score + right_arm_score )
        
        if (FeedbackUtilities.left_waist_angle(resultArray!) > FeedbackUtilities.right_waist_angle(resultArray!)) {
            left_waist_score = FeedbackUtilities.left_waist(resultArray!, 120.0, 20, true)
            right_waist_score = FeedbackUtilities.right_waist(resultArray!, 60.0, 20, true)
        }
        else {
            left_waist_score = FeedbackUtilities.left_waist(resultArray!, 60.0, 20, true)
            right_waist_score = FeedbackUtilities.right_waist(resultArray!, 120.0, 20, true)
        }
        
        let waist_score = [left_waist_score, right_waist_score].min()
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20, true)
        let leg_score = 0.5*( left_leg_score + right_leg_score )
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_lw | cb_rw
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = arm_ratio*arm_score + waist_ratio*waist_score! + leg_ratio*leg_score
        detailedscore = [arm_score, waist_score!, leg_score]
        
    }
    
    private func makeComment(){
        comment = Array<String>()
        
        comment!.append("The Arms' Straightness" + FeedbackUtilities.comment(arm_score))
        comment!.append("The Waist's Bending Angle " + FeedbackUtilities.comment(waist_score))
        comment!.append("The Legs' Straightness " + FeedbackUtilities.comment(leg_score))

    }
    

}
