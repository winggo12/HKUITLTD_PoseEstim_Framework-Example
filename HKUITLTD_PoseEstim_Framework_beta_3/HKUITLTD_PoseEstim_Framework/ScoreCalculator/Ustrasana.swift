import Foundation

public class Ustrasana {
    
    var waist_ratio: Double
    var leg_ratio: Double
    var arm_ratio: Double
    var arm_score: Double
    var waist_score: Double
    var leg_score: Double
    var final_score: Double
    var result : Result
    var keypoints: Array<Array<Double>>

    public init(user_input_result :Result){

    self.waist_ratio = 0.1
    self.leg_ratio = 0.5
    self.arm_ratio = 0.4
    self.arm_score = 0
    self.waist_score = 0
    self.leg_score = 0
    self.final_score = 0
    self.result = user_input_result
    self.keypoints = ResultToArray(result: self.result)
    
    }
    
    public func vertical_waist(kps:Array<Array<Double>>) -> Double{
        let left_shoulder = kps[2]
        let left_hip = kps[8]
        let left_knee = kps[10]
        let angle = get_angle(center_coord: left_hip, coord1: left_shoulder, coord2: left_knee)
        if angle < 100{
            return 100
        }
        if angle >= 100 && angle < 120 {
            return 90
        }
        if angle >= 120 && angle < 140 {
            return 80
        }
        if angle >= 140 && angle < 160 {
            return 70
        }
        else{
            return 60
        }
    }
    
    public func straight_arm(kps:Array<Array<Double>>)->Double{
        let left_elbow = kps[3]
        let left_shoulder = kps[1]
        let left_wrist = kps[5]
        let arm_angle = get_angle(center_coord: left_elbow, coord1: left_shoulder, coord2: left_wrist)

        if arm_angle > 170{
            return 100
        }

        if arm_angle > 150{
            return 90
        }

        if arm_angle > 130{
            return 80
        }

        if arm_angle > 110{
            return 70
        }
        else{
            return 60
        }
    }
    
    public func straight_leg(kps:Array<Array<Double>>)->Double{
        let left_knee = kps[9]
        let left_hip = kps[7]
        let left_ankle = kps[11]
        let leg_angle = get_angle(center_coord: left_knee, coord1: left_ankle, coord2: left_hip)
        if abs(leg_angle - 90) < 5{
            return 100
        }

        if abs(leg_angle - 90) < 15 && abs(leg_angle - 90) >= 5{
            return 90
        }

        if abs(leg_angle - 90) < 25 && abs(leg_angle - 90) >= 15{
            return 80
        }
        if abs(leg_angle - 90) < 35 && abs(leg_angle - 90) >= 25{
            return 70
        }
        else{
            return 60
        }
    }
    
    public func get_score() -> Double{
        self.keypoints = ResultToArray(result: self.result)
        self.arm_score = self.arm_ratio * Double(straight_arm(kps: self.keypoints))
        self.waist_score = self.waist_ratio * Double(vertical_waist(kps:self.keypoints))
        self.leg_score = self.leg_ratio * Double(straight_leg(kps: self.keypoints))
        self.final_score = arm_score + waist_score + leg_score
        return self.final_score
    }
    

    public func get_recommendation()-> [String] {
    var c : [String] = []

    var c1 =  "The Straightness of the Arms " + comment(score: straight_arm(kps:self.keypoints))

    var c2 = "The Curvature of the Body " + comment(score: vertical_waist(kps:self.keypoints))

    var c3 =  "The Curvature of the Legs " + comment(score: straight_leg(kps:self.keypoints))

    c += [c1,c2,c3]

    return c
    }
}



