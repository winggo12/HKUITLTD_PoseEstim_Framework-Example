//
//  Balasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class Balasana: YogaBase{

    /** constant */
    private var hip_foot_ratio: Double = 0.5
    private var shoulder_knee_ratio: Double = 0.5

    /** score of body parts */
    private var hip_foot_score: Double = 0.0
    private var chest_knee_score: Double = 0.0

    /** constructor */
    
    init(result: Result) {
        super.init()
        self.result = result
        self.resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** private method */
    private func makeComment(){
        comment = Array<String>()
        comment!.append("$hip_foot_score, Hip-Foot Distance  " + FeedbackUtilities.comment(hip_foot_score))
        comment!.append("$chest_knee_score, Chest-Knee Distance " + FeedbackUtilities.comment(chest_knee_score))

    }


    private func calculateScore(){
        
        let leg_length = FeedbackUtilities.cal_dis(coor1: resultArray![7], coor2: resultArray![11])
        
        let hip_foot_dis = ( FeedbackUtilities.cal_dis(coor1: resultArray![7], coor2: resultArray![11]) + FeedbackUtilities.cal_dis(coor1: resultArray![8], coor2: resultArray![12]) )*0.5
        let chest_knee_dis = ( FeedbackUtilities.cal_dis(coor1: resultArray![1], coor2: resultArray![9]) + FeedbackUtilities.cal_dis(coor1: resultArray![2], coor2: resultArray![10]) )*0.5
        
        hip_foot_score = FeedbackUtilities.disToScore(hip_foot_dis, 10, 5, true)
        chest_knee_score = FeedbackUtilities.disToScore(chest_knee_dis, 10, 5, true)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: hip_foot_score)
        let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: hip_foot_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: chest_knee_score)
        let cb_rw:UInt = ColorFeedbackUtilities.right_waist(score: chest_knee_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_lw | cb_rw
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        
        colorbit = Array(colorbitmergeString.substring(from: index))
        score = 0.5*(hip_foot_score+chest_knee_score)
        detailedscore = [hip_foot_score, chest_knee_score]
        
    }
    
}
