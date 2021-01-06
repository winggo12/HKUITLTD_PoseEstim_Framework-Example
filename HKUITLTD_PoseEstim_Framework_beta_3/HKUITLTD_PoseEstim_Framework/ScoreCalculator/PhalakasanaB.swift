//
//  PhalakasanaB.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class PhalakasanaB: YogaBase{

        /** constant */
        private var shoulder_ratio: Double = 0.4
        private var leg_ratio: Double = 0.2
        private var hand_elbow_foot_ratio: Double = 0.4

        /** score of body parts */
        private var shoulder_score: Double = 0.0
        private var leg_score: Double = 0.0
        private var hand_elbow_foot_score: Double = 0.0
    
        /** constructor */
        
        init(result: Result) {
            super.init()
            self.result = result
            self.resultArray = result.classToArray()
            calculateScore()
            makeComment()
        }

        /** private method */
        private func makeComment(){
            comment = Array<String>()
            comment!.append("$waist_score, Distance between Hand,Elbow,Foot and Ground " + FeedbackUtilities.comment(hand_elbow_foot_score))
            comment!.append("$shoulder_score, The Posture of the Shoulder " + FeedbackUtilities.comment(shoulder_score))
            comment!.append("$shoulder_score, The Posture of the Leg " + FeedbackUtilities.comment(leg_score))

        }

        private func calculateScore(){
            
            let left_leg_score = FeedbackUtilities.left_leg(resultArray!, 180.0, 20.0, true)
            let right_leg_score = FeedbackUtilities.right_leg(resultArray!, 180.0, 20.0, true)
            leg_score = 0.5*(right_leg_score + left_leg_score)
            
            let left_shoulder_score = FeedbackUtilities.left_shoulder(resultArray!, 90.0, 10.0, true)
            let right_shoulder_score = FeedbackUtilities.right_shoulder(resultArray!, 90.0, 10.0, true)
            shoulder_score = 0.5*(left_shoulder_score + right_shoulder_score)
            
            let left_hand_elbow_foot_angle = FeedbackUtilities.getAngle(resultArray![7], resultArray![3], resultArray![11])
            let left_hand_elbow_foot_score = FeedbackUtilities.angleToScore(left_hand_elbow_foot_angle, 180, 20, true)
            let right_hand_elbow_foot_angle = FeedbackUtilities.getAngle(resultArray![8], resultArray![4], resultArray![12])
            let right_hand_elbow_foot_score = FeedbackUtilities.angleToScore(left_hand_elbow_foot_angle, 180, 20, true)
            hand_elbow_foot_score = 0.5 * (left_hand_elbow_foot_score + right_hand_elbow_foot_score)
            
            let cb_ll:UInt = ColorFeedbackUtilities.left_leg(score: left_leg_score)
            let cb_rl:UInt = ColorFeedbackUtilities.right_leg(score: right_leg_score)
            
            let cb_ls:UInt = ColorFeedbackUtilities.left_shoulder(score: left_shoulder_score)
            let cb_rs:UInt = ColorFeedbackUtilities.right_shoulder(score: right_shoulder_score)

            let colorbitmerge: UInt = cb_ll | cb_rl | cb_ls | cb_rs
            colorbit = ColorFeedbackUtilities.uint_to_array(colorbitmerge: colorbitmerge)
            
            score = shoulder_ratio*shoulder_score + leg_ratio*leg_score + hand_elbow_foot_ratio*hand_elbow_foot_score
            detailedscore = [shoulder_score, leg_score, hand_elbow_foot_score]
            
        }

    }
