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
    private var detailedscore:[Double] = [Double]()
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
                detailedscore = YogaPose.getDetailedScore()
            case Pose.ArdhaChandarasana:
                let YogaPose = ArdhaChandarasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.AdhoMukhaShivanasana:
                let YogaPose = AdhoMukhaShivanasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.BaddhaKonasana:
                let YogaPose = BaddhaKonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.Balasana:
                let YogaPose = Balasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.Bhujangasana:
                let YogaPose = Bhujangasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.CaturangaDandasana:
                let YogaPose = CaturangaDandasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.Dandasana:
                let YogaPose = Dandasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.Halasana:
                let YogaPose = Halasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.MarjarasanaB:
                let YogaPose = MarjarasanaB(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.MarjarasanaC:
                let YogaPose = MarjarasanaB(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.Natarajasana:
                let YogaPose = Natarajasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.Navasana:
                let YogaPose = Navasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.Padangushthasana:
                let YogaPose = Padangushthasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.ParivrttaPashvaKonasana:
                let YogaPose = ParivrttaPashvaKonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.ParivrttaTrikonasana:
                let YogaPose = ParivrttaTrikonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.PurnaShalabhasana:
                let YogaPose = PurnaShalabhasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.Tuladandasana:
                let YogaPose = Tuladandasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.UbhayaPadangushtasana:
                let YogaPose = UbhayaPadangushtasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UrdhvaDhanurasana:
                let YogaPose = UrdhvaDhanurasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.Ustrasana:
                let YogaPose = Ustrasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UttanaPadasana:
                let YogaPose = UttanaPadasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UtthitaHastaPadangusthasanaB:
                let YogaPose = UtthitaHastaPadangusthasanaA(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UtthitaHastaPadangusthasanaA:
                let YogaPose = UtthitaHastaPadangusthasanaA(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UtthitaHastaPadangusthasanaC:
                let YogaPose = UtthitaHastaPadangusthasanaC(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UtthitaParsvakonasana:
                let YogaPose = UtthitaParsvakonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.Utkatasana:
                let YogaPose = Utkatasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UrdhvaMukhaSvanasana:
                let YogaPose = UrdhvaMukhaSvanasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.UtthitaTrikonasana:
                let YogaPose = UtthitaTrikonasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            case Pose.VirabhadrasanaA:
                let YogaPose = VirabhadrasanaA(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.VirabhadrasanaB:
                let YogaPose = VirabhadrasanaB(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.VirabhadrasanaC:
                let YogaPose = VirabhadrasanaC(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.VirabhadrasanaD:
                let YogaPose = VirabhadrasanaD(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            case Pose.Vrksasana:
                if(vrksasana == nil){
                    vrksasana = Vrksasana(result: self.result)
                }else{
                    vrksasana!.setResult(result: self.result)
                }
                score = vrksasana!.getScore()
                comments = vrksasana!.getComment()
                detailedscore = vrksasana!.getDetailedScore()

            case Pose.TPose:
                let YogaPose = TPose(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()
            
            default:
                let YogaPose = Navasana(result: self.result)
                score = YogaPose.getScore()
                comments = YogaPose.getComment()
                detailedscore = YogaPose.getDetailedScore()

            }
        }

        public func getScore() -> Double {return self.score}
        public func getComments() -> [String] {return self.comments}
        public func getDetailedScore() -> [Double] {return self.detailedscore}
}
