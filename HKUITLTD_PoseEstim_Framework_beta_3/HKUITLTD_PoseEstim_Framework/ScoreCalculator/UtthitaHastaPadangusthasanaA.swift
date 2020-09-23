//
//  UtthitaHastaPadangusthasanaA.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation


class UtthitaHastaPadangusthasanaA {
    
    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil


    /** constant */
    private let leg_ratio = 0.7
    private let waist_ratio = 0.2
    private let arm_ratio = 0.1

    /** score of body parts */
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0

    private var side: Int = -1
    
    private var leg_lenth: Double = 0.0
    private var wrist_to_ankle_distance: Double = 0.0
    
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
        side = detectSide()
        arm_score = arm()
        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        leg_score = 0.5 * (left_leg_score + right_leg_score)

        switch(side){
        case 11:
            waist_score = utilities.right_waist(resultArray!, 180.0, 20.0, true)
        default:
            waist_score = utilities.left_waist(resultArray!, 180.0, 20.0, true)
        }
        score = leg_ratio * leg_score + waist_ratio * waist_score + arm_ratio * arm_score
        detailedscore = [arm_score, waist_score, leg_score]
    }

    private func makeComment(){
        comment = Array<String>()
        comment!.append("The Wrist-To-Ankle distance " + comment_wrist_ankle_distance(arm_score))
        comment!.append("The Curvature of the Body " + utilities.comment(waist_score))
        comment!.append("The Curvature of the Legs " + utilities.comment(leg_score))

    }

    private func arm()-> Double {

        let r_wrist = resultArray![6]
        let r_ankle = resultArray![12]
        let r_knee = resultArray![10]
        let l_wrist = resultArray![5]
        let l_ankle = resultArray![11]
        let l_knee = resultArray![9]
        switch(side){
        case 11:
            leg_lenth = utilities.cal_dis(coor1: l_ankle, coor2: l_knee)
            wrist_to_ankle_distance = utilities.cal_dis(coor1: l_ankle, coor2: l_wrist)
        default:
            leg_lenth = utilities.cal_dis(coor1: r_ankle, coor2: r_knee)
            wrist_to_ankle_distance = utilities.cal_dis(coor1: r_ankle, coor2: r_wrist)
        }


        if(wrist_to_ankle_distance < leg_lenth * 0.2){
            return 100.0
        }else {
            return 90.0
        }

    }
    private func detectSide()-> Int{
        let l_ankle = resultArray![11]
        let r_ankle = resultArray![12]
        if(l_ankle[1] < r_ankle[1]){
            return 11
        }else{
            return 12
        }
    }
    private func comment_wrist_ankle_distance(_ score: Double)-> String{
        if(score == 100.0){
            return " is great"
        }else{
            return " is not ideal"
        }
    }
}
