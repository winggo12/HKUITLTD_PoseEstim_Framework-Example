//
//  Vrkshasana.swift
//  PoseEstim
//
//  Created by iosuser111 on 5/6/2020.
//  Copyright © 2020 tensorflow. All rights reserved.
//

import Foundation
import os
class Vrksasana {

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var left_right_thigh_ratio: Double = 0.5
    private var time_ratio: Double = 0.5

    /** score of body parts */
    private var left_right_thigh_score: Double = 0.0
    private var time_score: Double = 0.0
    
    /** unit = ns */
    private var start_time: UInt64 = 0
    private var timer_ns: UInt64 = 0
    private var isStartTiming: Bool = false

    /** average angle */
    private var l_hip_average: Double = 0.0
    private var r_hip_average: Double = 0.0
    private var l_knee_average: Double = 0.0
    private var r_knee_average: Double = 0.0
    /** constructor */
    init(result: Result){
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }
    
    func setResult(result: Result){
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }
    /** getter */
    func getScore()-> Double {return self.score!}
    func getComment()-> Array<String> {return self.comment!}
    func getResult()-> Result {return self.result!}
    func getDetailedScore()-> Array<Double>{return detailedscore!}

    /** private method */
    private func calculateScore(){
        
        strat_timing()
        time_score = cal_time_score(start_time)
        left_right_thigh_score = utilities.right_left_leg(resultArray!, 90.0, 20.0, false)
        score = left_right_thigh_ratio * left_right_thigh_score + time_ratio * time_score
        detailedscore = [left_right_thigh_score, time_score, (Double(timer_ns) / 1_000_000_000) ]

    }

    private func makeComment(){
        comment = Array<String>()
        comment!.append("The angle between left and right thigh: " + utilities.comment(left_right_thigh_score))
        comment!.append("The time of standing: " + String(Double(timer_ns) / 1_000_000_000))
        comment!.append("start time: " + String(Double(start_time) / 1_000_000_000))
        
        withUnsafePointer(to: self) { comment!.append("self = \($0)") }
    }

    private func strat_timing(){
        
        let left_shoulder = resultArray![1]
        let left_hip = resultArray![7]
        let left_knee = resultArray![9]
        let left_ankle = resultArray![11]
        let angle1 = utilities.getAngle(left_hip, left_shoulder, left_knee)
        let angle2 = utilities.getAngle(left_knee, left_hip, left_ankle)

        let right_shoulder = resultArray![2]
        let right_hip = resultArray![8]
        let right_knee = resultArray![10]
        let right_ankle = resultArray![12]
        let angle3 = utilities.getAngle(right_hip, right_shoulder, right_knee)
        let angle4 = utilities.getAngle(right_knee, right_hip, right_ankle)

        l_hip_average = cal_average_angle(oldAverage: l_hip_average, newData: angle1)
        l_knee_average = cal_average_angle(oldAverage: l_knee_average, newData: angle2)
        r_hip_average = cal_average_angle(oldAverage: r_hip_average, newData: angle3)
        r_knee_average = cal_average_angle(oldAverage: r_knee_average, newData: angle4)
        
        if((abs(l_hip_average - 180.0) <= 20.0 && abs(l_knee_average - 180.0) <= 20.0)
            || (abs(r_hip_average - 180.0) <= 20.0 && abs(r_knee_average - 180.0) <= 20.0)
            ){
            let str = "isStartTiming = \(String(isStartTiming))"
            if(!isStartTiming){
                start_time = 0
                start_time = DispatchTime.now().uptimeNanoseconds
                isStartTiming = true
            }

        }else{
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
    private func cal_average_angle(oldAverage: Double, newData: Double)-> Double{
        return (oldAverage * 3 + newData) / 4
    }
}
