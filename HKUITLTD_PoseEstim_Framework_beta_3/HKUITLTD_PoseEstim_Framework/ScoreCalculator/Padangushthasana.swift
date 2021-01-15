//
//  Padangushthasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 31/12/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

//大脚趾站立山式
class Padangushthasana: YogaBase {

    /** constant */
    private let arm_ratio: Double = 0.4
    private let waist_ratio: Double = 0.3
    private let leg_ratio: Double = 0.3

    /** score of body parts */
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var body_score: Double = 0.0
    private var time_score: Double = 0.0
    
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
        
        start_timing()
        time_score = cal_time_score(start_time)
        score = arm_ratio * arm_score + waist_ratio * waist_score + leg_ratio * leg_score
        detailedscore = [arm_score, waist_score, leg_score]
        
    }
    
    private func makeComment(){
        comment = Array<String>()
        
        comment!.append("The Straightness of the Arms " + FeedbackUtilities.comment(body_score))
        comment!.append("The time of standing: " + String(Double(timer_ns) / 1_000_000_000))

    }
    
    private func start_timing()
    {
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180.0, 20.0, true)
        arm_score =  0.5 * (left_arm_score + right_arm_score)
        
        let left_waist_score = FeedbackUtilities.left_waist(resultArray!, 180.0, 20, true)
        let right_waist_score = FeedbackUtilities.right_waist(resultArray!, 180.0, 20, true)
        waist_score = 0.5 * (left_waist_score + right_waist_score)
        
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20, true)
        leg_score = 0.5 * (left_leg_score + right_leg_score)
        
        let body_score = [arm_score,waist_score,leg_score].min()
        if(body_score! > 80.0)
        {
            if(!isStartTiming)
            {
                start_time = 0
                start_time = DispatchTime.now().uptimeNanoseconds
                isStartTiming = true
            }
        }
        else{
                start_time = 0
                isStartTiming = false
        }
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: right_waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_lw | cb_rw
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
    }
    
    private func cal_time_score(_ start_time: UInt64)-> Double{
        if(isStartTiming){
            timer_ns = DispatchTime.now().uptimeNanoseconds - start_time
            let timer_s = Double(timer_ns) / 1_000_000_000
            if(timer_s <= 20){
                return 70.0
            }else if(timer_s <= 40){
                return 80.0
            }else if(timer_s <= 60){
                return 90.0
            }else{
                return 100.0
            }
        }else{
            timer_ns = 0
            return 0.0
        }

    }
    

}
