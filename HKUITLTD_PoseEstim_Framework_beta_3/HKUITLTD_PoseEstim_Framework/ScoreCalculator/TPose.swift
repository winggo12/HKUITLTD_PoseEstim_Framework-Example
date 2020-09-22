import Foundation

class TPose {

    private let utilities: FeedbackUtilities = FeedbackUtilities()
    
    /** output */
    private var comment : Array<String>? = nil
    private var score : Double? = nil

    /** input */
    private var result: Result? = nil
    private var resultArray: Array<Array<Double>>? = nil
    private var detailedscore: Array<Double>? = nil

    /** constant */
    private let right_leg_ratio: Double = 0.4
    private let left_leg_ratio: Double = 0.4
    private let left_arm_ratio: Double = 0.1
    private let right_arm_ratio: Double = 0.1

    /** score of body parts */
    private var left_arm_score: Double = 0.0
    private var left_leg_score: Double = 0.0
    private var right_arm_score: Double = 0.0
    private var right_leg_score: Double = 0.0

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
    private func calculateScore(){
        let left_arm_score = self.T_left_arm(kps: resultArray!)
        let right_arm_score = self.T_right_arm(kps: resultArray!)
        let right_leg_score = self.straight_left_leg(kps: resultArray!)
        let left_leg_score = self.straight_right_leg(kps: resultArray!)

        score = left_leg_ratio * left_leg_score + right_leg_ratio * right_leg_score + left_arm_score * left_arm_ratio + right_arm_ratio * right_arm_score

    }
    
    private func T_right_arm(kps:Array<Array<Double>>)->Double{
        let r_elbow = kps[4]
        let r_shoulder = kps[2]
        let r_wrist = kps[6]
        let arm_angle = utilities.getAngle(r_elbow, r_shoulder, r_wrist)
        
        if arm_angle > 85 && arm_angle < 95 {
            return 100
        }
        if arm_angle > 75 && arm_angle < 105 {
            return 90
        }
        if arm_angle > 65 && arm_angle < 115 {
            return 90
        }
        if arm_angle > 55 && arm_angle < 125 {
            return 90
        }
        else{
            return 60
        }
    }

    private func T_left_arm(kps:Array<Array<Double>>)->Double{
        let l_elbow = kps[3]
        let l_shoulder = kps[1]
        let l_wrist = kps[5]
        let arm_angle = utilities.getAngle(l_elbow, l_shoulder, l_wrist)
        
        if arm_angle > 85 && arm_angle < 95 {
            return 100
        }
        if arm_angle > 75 && arm_angle < 105 {
            return 90
        }
        if arm_angle > 65 && arm_angle < 115 {
            return 80
        }
        if arm_angle > 55 && arm_angle < 125 {
            return 70
        }
        else{
            return 60
        }
    }

    private func straight_left_leg(kps:Array<Array<Double>>)->Double{
        let left_knee = kps[9]
        let left_hip = kps[7]
        let left_ankle = kps[11]
        let leg_angle = utilities.getAngle(left_knee, left_ankle, left_hip)
        if leg_angle > 170{
            return 100
        }
        if leg_angle > 150{
            return 90
        }
        if leg_angle>120{
            return 80
        }
        if leg_angle > 90{
            return 70
        }
        else{
            return 60
        }
    }
    
    private func straight_right_leg(kps:Array<Array<Double>>)->Double{
        let right_knee = kps[10]
        let right_hip = kps[8]
        let right_ankle = kps[12]
        let leg_angle = utilities.getAngle(right_knee, right_ankle, right_hip)
        if leg_angle > 170{
            return 100
        }
        if leg_angle > 150{
            return 90
        }
        if leg_angle>120{
            return 80
        }
        if leg_angle > 90{
            return 70
        }
        else{
            return 60
        }
    }


    private func makeComment()->Array<String>{
        comment = Array<String>()
        comment!.append("TPose")
        
        return comment!
    }
}
