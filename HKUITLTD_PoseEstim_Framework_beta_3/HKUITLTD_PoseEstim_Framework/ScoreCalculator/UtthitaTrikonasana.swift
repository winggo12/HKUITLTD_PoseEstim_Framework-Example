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
    private let colorutilities: ColorFeedbackUtilities = ColorFeedbackUtilities()
    
    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil
    private var colorbit: Array<Character>? = nil
    
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
    func getColorBit()->Array<Character>{return colorbit!}
    
    /** private method */
    private func calculateScore(){
        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, true)
        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, true)
        let arm_score =  0.5*( left_arm_score + right_arm_score )
        
        let left_waist_score = utilities.left_waist(resultArray!, 180.0, 20, true)
        let right_waist_score = utilities.right_waist(resultArray!, 180.0, 20, true)
        let waist_score = [left_waist_score, right_waist_score].min()
        
        let left_leg_score = utilities.left_leg(resultArray!, 180.0, 20, true)
        let right_leg_score = utilities.right_leg(resultArray!, 180.0, 20, true)
        let leg_score = 0.5*( left_leg_score + right_leg_score )
        
        let cb_ll:UInt = colorutilities.left_leg(score: left_leg_score)
        let cb_rl:UInt = colorutilities.right_leg(score: right_leg_score)
        
        let cb_la:UInt = colorutilities.left_arm(score: left_arm_score)
        let cb_ra:UInt = colorutilities.right_arm(score: right_arm_score)
        
        let cb_lw:UInt = colorutilities.left_waist(score: left_waist_score)
        let cb_rw:UInt = colorutilities.right_waist(score: right_waist_score)
        
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
        
        comment!.append("The Arms' Straightness" + utilities.comment(arm_score))
        comment!.append("The Waist's Bending Angle " + utilities.comment(waist_score))
        comment!.append("The Legs' Straightness " + utilities.comment(leg_score))

    }
    

}
