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
    private var vrksasana: Vrksasana? = nil
    public init(user_input_result :Result,user_input_pose :Pose){
        self.result = user_input_result
        self.currentPose = user_input_pose
        self.score = 0
        self.comments = [String]()
        self.generateFeedback(user_input_result :user_input_result, user_input_pose :user_input_pose)
    }
    
    public func generateFeedback(user_input_result :Result,user_input_pose :Pose){
        self.result = user_input_result
        self.currentPose = user_input_pose
        switch currentPose {
            case Pose.ArdhaUttanasana:
                let YogaPose = ArdhaUttanasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.ArdhaChandarasana:
                let YogaPose = ArdhaChandarasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.AdhoMukhaShivanasana:
                let YogaPose = AdhoMukhaShivanasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.BaddhaKonasana:
                let YogaPose = BaddhaKonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Bhujangasana:
                let YogaPose = Bhujangasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.CaturangaDandasana:
                let YogaPose = CaturangaDandasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Dandasana:
                let YogaPose = Dandasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Halasana:
                let YogaPose = Halasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Natarajasana:
                let YogaPose = Natarajasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Navasana:
                let YogaPose = Navasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.ParivrttaPashvaKonasana:
                let YogaPose = ParivrttaPashvaKonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.ParivrttaTrikonasana:
                let YogaPose = ParivrttaTrikonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.PurnaShalabhasana:
                let YogaPose = PurnaShalabhasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Tuladandasana:
                let YogaPose = Tuladandasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.UbhayaPadangushtasana:
                let YogaPose = UbhayaPadangushtasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.UrdhvaDhanurasana:
                let YogaPose = UrdhvaDhanurasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Ustrasana:
                let YogaPose = Ustrasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.UttanaPadasana:
                let YogaPose = UttanaPadasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.UtthitaHastaPadangusthasanaB:
                let YogaPose = UtthitaHastaPadangusthasanaA(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.UtthitaHastaPadangusthasanaA:
                let YogaPose = UtthitaHastaPadangusthasanaA(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.UtthitaHastaPadangusthasanaC:
                let YogaPose = UtthitaHastaPadangusthasanaC(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            case Pose.Vrksasana:
                if(vrksasana == nil){
                    vrksasana = Vrksasana(result: self.result)
                }else{
                    vrksasana!.setResult(result: self.result)
                }
                score = vrksasana!.getScore()
                comments = vrksasana!.getComment()
            case Pose.UtthitaParsvakonasana:
                let YogaPose = UtthitaParsvakonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
            default:
                let YogaPose = Navasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()

            }
        }

        public func getScore() -> Double {return self.score}
        public func getComments() -> [String] {return self.comments}
}
