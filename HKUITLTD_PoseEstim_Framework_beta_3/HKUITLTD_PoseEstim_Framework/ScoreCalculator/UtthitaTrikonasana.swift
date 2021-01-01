//
//  UtthitaTrikonasana  .swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 31/12/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class UtthitaTrikonasana {
    
    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private let leg_ratio = 0.4
    private let waist_ratio = 0.4
    private let arm_ratio = 0.2

    /** score of body parts */
    private var leg_score: Double = 0.0
    private var arm_score: Double = 0.0
    private var waist_score: Double = 0.0
    private var shoulder_score: Double = 0.0
    
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
        let arm_score =  0.5*(utilities.left_arm(resultArray!, 180.0, 20.0, true) + utilities.right_arm(resultArray!, 180.0, 20.0, true))
        var left_waist_score = utilities.left_waist(resultArray!, 180.0, 20, true)
        var right_waist_score = utilities.right_waist(resultArray!, 180.0, 20, true)
    
        let waist_score = [left_waist_score, right_waist_score].min()
        let leg_score = 0.5*(utilities.left_leg(resultArray!, 180.0, 20, true)+utilities.right_leg(resultArray!, 180.0, 20, true))
        score = arm_ratio*arm_score + waist_ratio*waist_score! + leg_ratio*leg_score
        detailedscore = [arm_score, waist_score!, leg_score]
        
    }
    
    private func makeComment(){
        comment = Array<String>()
        
        comment!.append("The Arms' Straightness" + utilities.comment(arm_score))
        comment!.append("The Waist's Bending Angle " + utilities.comment(waist_score))
        comment!.append("The Legs' Straightness " + utilities.comment(leg_score))

    }
    

}
