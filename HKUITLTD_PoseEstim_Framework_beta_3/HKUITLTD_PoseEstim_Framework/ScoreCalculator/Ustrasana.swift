import Foundation

class Ustrasana {

    private let utilities: FeedbackUtilities = FeedbackUtilities()

    /** output */
    private var comment: Array<String>? = nil
    private var score: Double? = nil
    private var detailedscore: Array<Double>? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil

    /** constant */
    private var waist_ratio: Double = 0.4
    private var leg_ratio: Double = 0.5
    private var arm_ratio: Double = 0.1

    /** score of body parts */
    private var waist_score: Double = 0.0
    private var leg_score: Double = 0.0
    private var waist_angle: Double = 0.0
    private var arm_score: Double = 0.0

    
    /** constructor */
    init(result: Result){
        self.result = result
        resultArray = result.classToArray()
        calculateScore()
        makeComment()
    }

    /** getter */
    func getScore()-> Double { return  self.score! }
    func getComment()-> Array<String> { return self.comment! }
    func getResult()-> Result { return self.result! }
    func getDetailedScore()-> Array<Double>{return detailedscore!}
    /** private method */
    private func calculateScore()->Double{
        let right_leg_score = utilities.right_leg(resultArray!, 90.0, 20.0, false)
        let left_leg_score = utilities.left_leg(resultArray!, 90.0, 20.0, false)
        leg_score = 0.5 * (right_leg_score + left_leg_score)

        let right_arm_score = utilities.right_arm(resultArray!, 180.0, 20.0, true)
        let left_arm_score = utilities.left_arm(resultArray!, 180.0, 20.0, true)
        arm_score = 0.5 * (right_arm_score + left_arm_score)

        waist_score = utilities.right_waist(resultArray!, 90.0, 20.0, true)

        score = arm_ratio * arm_score + waist_ratio * waist_score + leg_ratio * leg_score
        detailedscore = [arm_score, waist_score, leg_score]
        return score!
    }

    private func makeComment()->Array<String>{
        comment = Array<String>()
        comment!.append("The Straightness of the Arms " + utilities.comment(arm_score))
        comment!.append("The Curvature of the Body " + utilities.comment(waist_score))
        comment!.append("The Curvature of the Legs " + utilities.comment(leg_score))

        return comment!
    }


}



