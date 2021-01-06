//
//  MarjarasanaC.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 3/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class MarjarasanaBLeft: YogaBase{

    /** constant */
    private let shoulder_ratio:Double = 0.0
    private let waist_ratio:Double = 0.0
    private let knee_ratio:Double = 0.0

    /** score of body parts */
    private var shoulder_score:Double = 0.0
    private var waist_score:Double = 0.0
    private var knee_score:Double = 0.0
    
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
        comment!.append("$waist_score, The Posture of the Waist " + FeedbackUtilities.comment(waist_score))

    }

    private func calculateScore(){
        
        shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 90, 110, true)
        
        waist_score = FeedbackUtilities.left_waist(resultArray!, 90, 10, true)
        
        knee_score = FeedbackUtilities.left_leg(resultArray!, 90, 10, true)
        
        let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: knee_score)

        let cb_la:UInt = ColorFeedbackUtilities.left_arm(score: shoulder_score)
        
        let cb_lw:UInt = ColorFeedbackUtilities.left_waist(score: waist_score)
        
        let colorbitmerge: UInt = cb_ll | cb_la | cb_lw
        
        colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
        score = knee_ratio*knee_score + shoulder_ratio*shoulder_score + waist_ratio*waist_score
        detailedscore = [shoulder_score, waist_score, knee_score]
        
    }

}
