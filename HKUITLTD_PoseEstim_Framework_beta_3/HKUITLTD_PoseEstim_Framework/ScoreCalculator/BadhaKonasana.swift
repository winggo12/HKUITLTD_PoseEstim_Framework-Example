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

    /** private method */
    private func makeComment(){
        comment =  Array<String>()
        comment!.append("The Curvature of the Legs " + utilities.comment(score!))

    }

    private func calculateScore(){
        let left_leg_score = utilities.left_leg(resultArray!, 0.0, 10.0, false)
        let right_leg_score = utilities.right_leg(resultArray!, 0.0, 10.0, false)
        score = 0.5 * (left_leg_score + right_leg_score)

    }


}
