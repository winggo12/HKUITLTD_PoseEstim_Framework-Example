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
    private var start_time: UInt64
    private var timer_ns: UInt64 = 0
    private var isStartTiming: Bool
    
    /** constructor */
    init(result: Result, timingFlag: Bool, start_time: UInt64){
        self.result = result
        self.start_time = start_time
        isStartTiming = timingFlag
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** getter */
    func getScore()-> Double { return self.score! }
    func getComment()-> Array<String> { return self.comment! }
    func getResult()-> Result { return self.result! }
    func getDetailedScore()-> Array<Double>{return detailedscore!}
    func getTimingFlag()-> Bool { return isStartTiming }
    func getStartTime()-> UInt64 { return self.start_time }
    
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
        arm_score =  0.5*(utilities.left_arm(resultArray!, 180.0, 20.0, true) + utilities.right_arm(resultArray!, 180.0, 20.0, true))
        shoulder_score = 0.5*(utilities.left_shoulder(resultArray!, 180.0, 20, true)+utilities.right_shoulder(resultArray!, 180.0, 20, true))
        waist_score = 0.5*(utilities.left_waist(resultArray!, 90.0, 20, true)+utilities.right_waist(resultArray!, 90.0, 20, true))
        leg_score = 0.5*(utilities.left_leg(resultArray!, 90.0, 20, true)+utilities.right_leg(resultArray!, 90.0, 20, true))
        
//        let body_score = [arm_score,shoulder_score,waist_score,leg_score].min()
        body_score = (arm_score + shoulder_score + waist_score + leg_score)/4
        
        if(body_score > 80.0 && !isStartTiming)
        {
            start_time = DispatchTime.now().uptimeNanoseconds
            isStartTiming = true
            print("start? -> \(isStartTiming)")
        }
    }
    
    private func cal_time_score(_ start_time: UInt64)-> Double{
        if(isStartTiming){
            timer_ns = DispatchTime.now().uptimeNanoseconds - start_time
            let timer_s = Double(timer_ns) / 1_000_000_000
            print("timer: \(timer_s) s")
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
            return 0.0
        }

    }
    

}
