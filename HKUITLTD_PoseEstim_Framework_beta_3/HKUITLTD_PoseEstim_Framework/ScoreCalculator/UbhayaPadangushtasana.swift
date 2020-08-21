//
//  UbhayaPadangushtasana.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by iosuser111 on 20/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class UbhayaPadangushtasana{
    
    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment : Array<String>? = nil
    private var score : Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */


    /** score of body parts */
    private var arm_score: Double = 0.0
    private var leg_score1: Double = 0.0
    private var leg_score2: Double = 0.0

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
    private func calculateScore()->Double{

        let r_score = utilities.right_waist(resultArray!, 30.0, 20.0, true)
        let l_score = utilities.left_waist(resultArray!, 30.0, 20.0, true)

        if(l_score > r_score){
            score = l_score
        }else{
            score = r_score
        }

        return score!
    }

    private func makeComment()->Array<String>{

        comment =  Array<String>()
        comment!.append("The Straightness of the Arms " + utilities.comment( arm_score))
        comment!.append("The Waist-to-Thigh Distance " + utilities.comment( leg_score1))
        comment!.append("The Straightness of the Legs " + utilities.comment( leg_score2))

        return comment!
    }


}
