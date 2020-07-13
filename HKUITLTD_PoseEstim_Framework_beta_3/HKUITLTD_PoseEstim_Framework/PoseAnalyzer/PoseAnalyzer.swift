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
            var YogaPose = Navasana(user_input_result: self.result)
            score = YogaPose.get_score()
            comments = YogaPose.get_recommendation()
            
        case Pose.ustrasana:
            var YogaPose = Ustrasana(user_input_result: self.result)
            score = YogaPose.get_score()
            comments = YogaPose.get_recommendation()

        case Pose.ardha_uttanasana:
            var YogaPose = ArdhaUttanasana(user_input_result: self.result)
            score = YogaPose.get_score()
            comments = YogaPose.get_recommendation()

        }


}
    public func getScore() -> Double {return self.score}
    public func getComments() -> [String] {return self.comments}
}
