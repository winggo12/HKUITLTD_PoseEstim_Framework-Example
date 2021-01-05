//
//  FeedbackUtilities.swift
//  HKUITLTD_PoseEstim_Framew

//
//  Created by iosuser111 on 18/8/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class FeedbackUtilities {

    static public func getAngle(_ center_coord: Array<Double>, _ coord1: Array<Double>, _ coord2: Array<Double>) -> Double{

        let center_dis = cal_dis(coor1: coord1, coor2: coord2)
        let dis1 = cal_dis(coor1: center_coord, coor2: coord2)
        let dis2 = cal_dis(coor1: center_coord, coor2: coord1)
        let angle = cal_angle(length_center: center_dis, length1: dis1, length2: dis2)

        return angle

    }


    static public func cal_angle(length_center: Double, length1: Double, length2: Double) -> Double{
        let out = (pow(length1, 2) + pow(length2, 2) - pow(length_center, 2))/(2 * length1 * length2)
        do{
            let result = acos(out) * (180/Double.pi)
            return result
        }
        catch{
            let result = 180.0
            return result
        }
    }



    static public func cal_dis(coor1: Array<Double>, coor2: Array<Double>) -> Double {

        let out = pow(coor1[0]-coor2[0],2) + pow(coor1[1]-coor2[1],2)
        return sqrt(out)

    }


    static func comment(_ score: Double)-> String{
        if(score < 79.0){
            return " is not ideal"
        }else if(score > 81.0){
            return " is great"
        }else{
            return " is okay"
        }
    }

    static func straightnessScore(_ angle:Double)-> Double{
        if(angle > 179){
            return 100.0
        }else if(angle > 150){
            return 90.0
        }else if(angle > 130){
            return 80.0
        }else if(angle > 110){
            return 70.0
        }else{
            return 60.0
        }
    }

    static func rightAngleScore(_ angle:Double)-> Double{
        if(abs(angle - 90) < 5){
            return 100.0
        }else if(abs(angle - 90) < 10){
            return 90.0
        }else if(abs(angle - 90) < 20){
            return 80.0
        }else if(abs(angle - 90) < 30){
            return 70.0
        }else{
            return 60.0
        }

    }

    static func angleToScore(_ angle: Double, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        if(excat) {
            if(abs(angle - fullMarkAngle) < 2){
                return 100.0
            }else if(abs(angle - fullMarkAngle) < step){
                return 90.0
                
            }else if(abs(angle - fullMarkAngle) < 2 * step){
                return 80.0
                
            }else if(abs(angle - fullMarkAngle) < 3 * step){
                return 70.0
                
            }else{
                return 60.0
                
            }

        }else{
            if(abs(angle - fullMarkAngle) < step){
                return 100.0
                
            }else if(abs(angle - fullMarkAngle) < 2 * step){
                return 90.0
                
            }else if(abs(angle - fullMarkAngle) < 3 * step){
                return 80.0
                
            }else if(abs(angle - fullMarkAngle) < 4 * step){
                return 70.0
                
            }else{
                return 60.0
                
            }
        }
    }
    
    static func disToScore(_ dis: Double, _ fullMarkDistance: Double, _ step: Double, _ excat:Bool)-> Double{
        if(excat) {
            if(abs(dis - fullMarkDistance) < 2){
                return 100.0
            }else if(abs(dis - fullMarkDistance) < step){
                return 90.0
                
            }else if(abs(dis - fullMarkDistance) < 2 * step){
                return 80.0
                
            }else if(abs(dis - fullMarkDistance) < 3 * step){
                return 70.0
                
            }else{
                return 60.0
                
            }

        }else{
            if(abs(dis - fullMarkDistance) < step){
                return 100.0
                
            }else if(abs(dis - fullMarkDistance) < 2 * step){
                return 90.0
                
            }else if(abs(dis - fullMarkDistance) < 3 * step){
                return 80.0
                
            }else if(abs(dis - fullMarkDistance) < 4 * step){
                return 70.0
                
            }else{
                return 60.0
                
            }
        }
    }


    /** analyze different parts of body and give a score */
    static func left_leg(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let left_knee = result[9]
        let left_hip = result[7]
        let left_ankle = result[11]

        let angle = getAngle(left_knee, left_ankle, left_hip)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func left_leg_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[9], result[7], result[13])
    }
    
    static func right_leg(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let r_knee = result[10]
        let r_hip = result[8]
        let r_ankle = result[12]
        let angle = getAngle(r_knee, r_ankle, r_hip)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func right_leg_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[10], result[8], result[12])
    }
    
    static func left_arm(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let left_elbow = result[3]
        let left_shoulder = result[1]
        let left_wrist = result[5]

        let angle = getAngle(left_elbow, left_wrist, left_shoulder)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func left_arm_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[3], result[1], result[5])
    }
    
    static func right_arm(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let r_elbow = result[4]
        let r_shoulder = result[2]
        let r_wrist = result[6]

        let angle = getAngle(r_elbow, r_shoulder, r_wrist)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func right_arm_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[4], result[2], result[6])
    }
    
    static func waist(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let left_shoulder = result[2]
        let left_hip = result[8]
        let left_knee = result[10]
        let angle = getAngle(left_hip, left_shoulder, left_knee)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    static func left_shoulder(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let left_shoulder = result[1]
        let left_hip = result[7]
        let left_elbow = result[3]
        let angle = getAngle(left_shoulder, left_hip, left_elbow)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func left_shoulder_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[1], result[7], result[3])
    }
    
    static func right_shoulder(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let right_shoulder = result[2]
        let right_hip = result[8]
        let right_elbow = result[4]
        let angle = getAngle(right_shoulder, right_hip, right_elbow)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func right_shoulder_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[2], result[8], result[4])
    }
    
    static func left_waist(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let left_shoulder = result[1]
        let left_hip = result[7]
        let left_knee = result[9]
        let angle = getAngle(left_hip, left_shoulder, left_knee)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func left_waist_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[7], result[1], result[9])
    }
    
    static func right_waist(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let right_shoulder = result[2]
        let right_hip = result[8]
        let right_knee = result[10]
        let angle = getAngle(right_hip, right_shoulder, right_knee)
        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func right_waist_angle(_ result:Array<Array<Double>>)-> Double{
        return getAngle(result[8], result[2], result[10])
    }
    
    static func right_left_leg(_ result:Array<Array<Double>>, _ fullMarkAngle: Double, _ step: Double, _ excat:Bool)-> Double{
        let left_hip = result[7]
        let left_knee = result[9]
        let right_hip = result[8]
        let right_knee = result[10]

        /** move line between right_hip and right_knee to make the above two lines intersect */
        let diffX = left_hip[0] - right_hip[0]
        let diffY = left_hip[1] - right_hip[1]
        let movedLine = moveLine(right_hip, right_knee, diffX, diffY)
        let new_right_hip = movedLine[0]
        let new_right_knee = movedLine[1]

        let angle = getAngle(new_right_hip, new_right_knee, left_knee)

        return angleToScore(angle, fullMarkAngle, step, excat)
    }
    
    static func decideDirection(_ resultArray:Array<Array<Double>>)-> Int{
        let left_wrist = resultArray[5]
        let right_wrist = resultArray[6]
        if(left_wrist[1] < right_wrist[1]){
            return 5
        }else{
            return 6
        }
    }
    
    static func movePoint(_ point:Array<Double>, _ diffX: Double, _ diffY: Double)-> Array<Double>{
        return[point[0]+diffX, point[1]+diffY]
    }
    static func moveLine(_ point1:Array<Double>, _ point2:Array<Double>, _ diffX: Double, _ diffY: Double)-> Array<Array<Double>>{
        let newPt1 = movePoint(point1, diffX, diffY)
        let newPt2 = movePoint(point2, diffX, diffY)
        return [newPt1, newPt2]
    }
}
