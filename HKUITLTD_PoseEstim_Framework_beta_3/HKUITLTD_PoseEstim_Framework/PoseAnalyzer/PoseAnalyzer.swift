//
//  PoseAnalyzer.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 26/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

public var selectedPose: Pose = Pose(rawValue: "navasana")!

public class GiveFeedBack{
    
    private var result : Result
    private var currentPose: Pose
    private var score: Double
    private var comments: [String] = [String]()
    
    public init(user_input_result :Result,user_input_pose :Pose){
        self.result = user_input_result
        self.currentPose = user_input_pose
        self.score = 0
        self.comments = [String]()
        self.generateFeedback()
    }
    
    private func generateFeedback(){
        switch currentPose {
        case Pose.navasana:
            let YogaPose = Navasana(result: self.result)
            score = YogaPose.getScore()
            comments = YogaPose.getComment()
            
        case Pose.ustrasana:
            let YogaPose = Ustrasana(result: self.result)
            score = YogaPose.getScore()
            comments = YogaPose.getComment()

        case Pose.ardha_uttanasana:
            let YogaPose = ArdhaUttanasana(result: self.result)
            score = YogaPose.getScore()
            comments = YogaPose.getComment()

        }


}
    public func getScore() -> Double {return self.score}
    public func getComments() -> [String] {return self.comments}
}
