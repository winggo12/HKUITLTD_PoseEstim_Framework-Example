import Foundation
import os
class TPose:YogaBase {

    /** constant */
    private let right_leg_ratio: Double = 0.1
    private let left_leg_ratio: Double = 0.1
    private let left_arm_ratio: Double = 0.4
    private let right_arm_ratio: Double = 0.4

    /** score of body parts */
    private var left_arm_score: Double = 0.0
    private var left_leg_score: Double = 0.0
    private var right_arm_score: Double = 0.0
    private var right_leg_score: Double = 0.0

    /** constructor */
    init(result: Result){
        super.init()
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }
    
    /** private method */
    private func calculateScore(){
        
        let left_arm_score = FeedbackUtilities.left_arm(resultArray!, 180, 20, true)
        let right_arm_score = FeedbackUtilities.right_arm(resultArray!, 180, 20, true)
        let left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 90, 10, true)
        let right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 90, 10, true)
        let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180, 20, true)
        let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180, 20, true)
        
        let cb_la = ColorFeedbackUtilities.left_arm(score: left_arm_score)
        let cb_ra = ColorFeedbackUtilities.right_arm(score: right_arm_score)
        let cb_ls = ColorFeedbackUtilities.left_shoulder(score: left_shoulder_score)
        let cb_rs = ColorFeedbackUtilities.right_shoulder(score: right_shoulder_score)
        let cb_ll = ColorFeedbackUtilities.left_leg(score: left_leg_score)
        let cb_rl = ColorFeedbackUtilities.right_leg(score: right_leg_score)
        
        let colorbitmerge: UInt = cb_ll | cb_rl | cb_la | cb_ra | cb_ls | cb_rs
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)

        colorbit = Array(colorbitmergeString.substring(from: index))
        
        score = left_leg_ratio * left_leg_score + right_leg_ratio * right_leg_score + left_arm_ratio * left_arm_score + right_arm_ratio * right_arm_score
        detailedscore = [left_leg_score, right_leg_score, left_arm_score, right_arm_score]
    }

    private func makeComment()->Array<String>{
        comment = Array<String>()
        comment!.append("TPose")
        
        return comment!
    }
}
