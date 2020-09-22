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
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var ratio: Double = 0.5

    /** score of body parts */
    private var leg_score: Double = 0.0
private var waist_score: Double = 0.0

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
        //TO BE MODIFIED
        let r_score = utilities.right_waist(resultArray!, 30.0, 20.0, false) //40
        let l_score = utilities.left_waist(resultArray!, 30.0, 20.0, false) //40

        if(l_score > r_score){
            waist_score = l_score
        }else{
            waist_score = r_score
        }

        let l_leg_score = utilities.left_leg(resultArray!, 180.0, 20.0, true)
        let r_leg_score = utilities.right_leg(resultArray!, 180.0, 20.0, true)
        leg_score = 0.5 * (l_leg_score + r_leg_score)
        score = ratio * (waist_score + leg_score)
        detailedscore = [waist_score, leg_score]
    }

    private func makeComment(){

        comment =  Array<String>()
        comment!.append("The curvature of body " + utilities.comment( waist_score))
        comment!.append("The straightness of legs " + utilities.comment( leg_score))


    }


}
