//
//  Balasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class Balasana{
    
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
    private var hip_foot_ratio: Double = 0.5
    private var shoulder_knee_ratio: Double = 0.5

    /** score of body parts */
    private var hip_foot_score: Double = 0.0
    private var chest_knee_score: Double = 0.0

    /** constructor */
    
    init(result: Result) {
        self.result = result
        self.resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** getter */
    func getScore()-> Double{ return score! }
    func getComment()-> Array<String>{return comment!}
    func getResult()-> Result{ return result!}
    func getDetailedScore()-> Array<Double>{return detailedscore!}
    func getColorBit()->Array<Character>{return colorbit!}
    
    /** private method */
    private func makeComment(){
        comment = Array<String>()
        comment!.append("$hip_foot_score, Hip-Foot Distance  " + utilities.comment(hip_foot_score))
        comment!.append("$chest_knee_score, Chest-Knee Distance " + utilities.comment(chest_knee_score))

    }


    private func calculateScore(){
        
        let leg_length = utilities.cal_dis(coor1: resultArray![7], coor2: resultArray![11])
        
        let hip_foot_dis = ( utilities.cal_dis(coor1: resultArray![7], coor2: resultArray![11]) + utilities.cal_dis(coor1: resultArray![8], coor2: resultArray![12]) )*0.5
        let chest_knee_dis = ( utilities.cal_dis(coor1: resultArray![1], coor2: resultArray![9]) + utilities.cal_dis(coor1: resultArray![2], coor2: resultArray![10]) )*0.5
        
        hip_foot_score = utilities.disToScore(hip_foot_dis, 10, 5, true)
        chest_knee_score = utilities.disToScore(chest_knee_dis, 10, 5, true)
        
        let cb_ll:UInt = colorutilities.left_leg(score: hip_foot_score)
        let cb_rl:UInt = colorutilities.right_leg(score: hip_foot_score)
        
        let cb_lw:UInt = colorutilities.left_waist(score: chest_knee_score)
        let cb_rw:UInt = colorutilities.right_waist(score: chest_knee_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_lw | cb_rw
        colorbit = colorutilities.uint_to_array(colorbitmerge: colorbitmerge)
        
        score = 0.5*(hip_foot_score+chest_knee_score)
        detailedscore = [hip_foot_score, chest_knee_score]
        
    }
    
}
