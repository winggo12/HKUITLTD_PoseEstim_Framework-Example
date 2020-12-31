//
//  Utkatasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 31/12/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class Utkatasana {
    
    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private let body_ratio = 0.1
    private let time_ratio = 0.9

    /** score of body parts */
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    private var body_score: Double = 0.0
    private var time_score: Double = 0.0
    
    /** unit = ns */
    private var start_time: UInt64 = 0
    private var timer_ns: UInt64 = 0
    private var isStartTiming: Bool = false
    
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
    private func calculateScore(){
        
        start_timing()
        time_score = cal_time_score(start_time)
        score = time_ratio * time_score + body_ratio * body_score
        detailedscore = [body_score, time_score]
        
    }
    
    private func makeComment(){
        comment = Array<String>()
        
        comment!.append("Upperbody's posture  " + utilities.comment(body_score))
        comment!.append("The time of standing: " + String(Double(timer_ns) / 1_000_000_000))

    }
    
    private func start_timing()
    {
        let arm_score =  0.5*(utilities.left_arm(resultArray!, 180.0, 20.0, true) + utilities.right_arm(resultArray!, 180.0, 20.0, true))
        let shoulder_score = 0.5*(utilities.left_shoulder(resultArray!, 180.0, 20, true)+utilities.right_shoulder(resultArray!, 180.0, 20, true))
        let waist_score = 0.5*(utilities.left_waist(resultArray!, 180.0, 20, true)+utilities.right_waist(resultArray!, 180.0, 20, true))
        let leg_score = 0.5*(utilities.left_leg(resultArray!, 90.0, 20, true)+utilities.right_leg(resultArray!, 90.0, 20, true))
        
        let body_score = [arm_score,shoulder_score,waist_score,leg_score].min()
        
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
