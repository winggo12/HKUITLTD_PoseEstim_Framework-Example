//
//  BadhaKonasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 19/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class BaddhaKonasana {

    private let utilities: FeedbackUtilities = FeedbackUtilities()
    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil
    
    private var left_leg_score: Double = 0.0
    private var right_leg_score: Double = 0.0
    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */

    /** score of body parts */

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
    private func makeComment(){
        comment =  Array<String>()
        comment!.append("The Curvature of the Legs " + utilities.comment(score!))
        comment!.append("Right leg: " + String(right_leg_score))
        comment!.append("left leg: " + String(left_leg_score))
    }

    private func calculateScore(){
        left_leg_score = utilities.left_leg(resultArray!, 0.0, 20.0, false)
        right_leg_score = utilities.right_leg(resultArray!, 0.0, 20.0, false)
        score = 0.5 * (left_leg_score + right_leg_score)
        detailedscore = [right_leg_score, left_leg_score]
    }


}
