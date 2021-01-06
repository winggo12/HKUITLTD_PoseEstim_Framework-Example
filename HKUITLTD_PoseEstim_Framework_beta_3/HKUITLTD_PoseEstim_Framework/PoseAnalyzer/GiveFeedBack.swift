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
    private var colorBit: [Character] = [Character]()
    private var YogaPose: YogaBase
    /** Getter */
    public func getScore() -> Double {return self.score}
    public func getComments() -> [String] {return self.comments}
    public func getDetailedScore() -> [Double] {return self.detailedscore}
    public func getColorBit() -> [Character] {return self.colorBit}
    
    public init(user_input_result :Result,user_input_pose :Pose){
        self.result = user_input_result
        self.currentPose = user_input_pose
        self.score = 0
        self.comments = [String]()
        self.YogaPose = TPose(result: self.result)
        self.colorBit = ["0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0"]
        self.generateFeedback(user_input_result :user_input_result, user_input_pose :user_input_pose)
    }
    
    public func generateFeedback(user_input_result :Result,user_input_pose :Pose){
        self.result = user_input_result
        self.currentPose = user_input_pose
        
        /** Pose with colorbit: Balasana, MarjarB,C, Padangushthasana, PhalakasanaB, UrdhvaMukhaSvansana, Utkatasana, UtthitaPashvakonasanaB
                          UtthitaTrikonasana, VirabhadrasanaABCD*/
        switch currentPose {
            case Pose.ArdhaUttanasana:
                YogaPose = ArdhaUttanasana(result: self.result)
                
            case Pose.AdhoMukhaShivanasana:
                 YogaPose = AdhoMukhaShivanasana(result: self.result)
           
            case Pose.Balasana:
                 YogaPose = Balasana(result: self.result)
       
            case Pose.MarjarasanaB:
                 YogaPose = MarjarasanaB(result: self.result)
    
            case Pose.MarjarasanaC:
                 YogaPose = MarjarasanaB(result: self.result)
           
            case Pose.Navasana:
                 YogaPose = Navasana(result: self.result)
 
            case Pose.Padangushthasana:
                 YogaPose = Padangushthasana(result: self.result)
 
            case Pose.UrdhvaDhanurasana:
                 YogaPose = UrdhvaDhanurasana(result: self.result)

            case Pose.UtthitaParsvakonasana:
                 YogaPose = UtthitaParsvakonasana(result: self.result)

            case Pose.UtthitaParsvakonasanaB:
                 YogaPose = UtthitaPashvakonasanaB(result: self.result)
                
            case Pose.Utkatasana:
                 YogaPose = Utkatasana(result: self.result)
                
            case Pose.UrdhvaMukhaSvanasana:
                 YogaPose = UrdhvaMukhaSvanasana(result: self.result)
                
            case Pose.UtthitaTrikonasana:
                 YogaPose = UtthitaTrikonasana(result: self.result)
                
            case Pose.VirabhadrasanaA:
                 YogaPose = VirabhadrasanaA(result: self.result)
                
            case Pose.VirabhadrasanaB:
                 YogaPose = VirabhadrasanaB(result: self.result)
                
            case Pose.VirabhadrasanaC:
                 YogaPose = VirabhadrasanaC(result: self.result)
                
            case Pose.VirabhadrasanaD:
                 YogaPose = VirabhadrasanaD(result: self.result)

            case Pose.TPose:
                 YogaPose = TPose(result: self.result)
            
            default:
                 YogaPose = TPose(result: self.result)
            }
        score = YogaPose.getScore()
        comments = YogaPose.getComment()
        detailedscore = YogaPose.getDetailedScore()
        colorBit = YogaPose.getColorBit()
    }
}
