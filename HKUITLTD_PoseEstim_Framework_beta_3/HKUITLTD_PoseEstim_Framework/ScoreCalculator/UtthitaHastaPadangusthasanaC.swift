//
//  UtthitaHastaPadangusthasanaC.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class UtthitaHastaPadangusthasanaC {

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private let leg_ratio = 0.6
    private let waist_ratio = 0.4

    /** score of body parts */
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0

    private var side: Int = -1
    
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
        
        let l_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        let r_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        leg_score = 0.5 * (l_leg_score + r_leg_score)
        
        var l_waist_score: Double = 0.0
        var r_waist_score: Double = 0.0
        switch(side){
            case 11:
                l_waist_score = utilities.left_waist(resultArray!, 0.0, 20.0, false)
                r_waist_score = utilities.right_waist(resultArray!, 180.0, 20.0, false)
            default:
                l_waist_score = utilities.left_waist(resultArray!, 180.0, 20.0, false)
                r_waist_score = utilities.right_waist(resultArray!, 0.0, 20.0, false)
        }

        waist_score = 0.5 * (l_waist_score + r_waist_score)
        score = leg_ratio * leg_score + waist_ratio * waist_score
        detailedscore = [waist_score, leg_score]
    }

    private func makeComment(){
        comment = Array<String>()

        comment!.append("The straightness of the Body " + utilities.comment(waist_score))
        comment!.append("The straightness of the Legs " + utilities.comment(leg_score))

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
}
