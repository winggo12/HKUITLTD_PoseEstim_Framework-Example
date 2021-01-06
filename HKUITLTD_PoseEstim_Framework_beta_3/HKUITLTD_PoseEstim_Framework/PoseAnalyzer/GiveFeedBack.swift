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
            case Pose.ArdhaUttanasanaLeft:
                YogaPose = ArdhaUttanasanaLeft(result: self.result)
            case Pose.ArdhaUttanasanaRight:
                YogaPose = ArdhaUttanasanaRight(result: self.result)
                
            case Pose.AdhoMukhaShivanasana:
                 YogaPose = AdhoMukhaShivanasana(result: self.result)
           
            case Pose.Balasana:
                 YogaPose = Balasana(result: self.result)
       
            case Pose.MarjarasanaBLeft:
                 YogaPose = MarjarasanaBLeft(result: self.result)
            case Pose.MarjarasanaBRight:
                 YogaPose = MarjarasanaBRight(result: self.result)
                
            case Pose.MarjarasanaCLeft:
                 YogaPose = MarjarasanaCLeft(result: self.result)
            case Pose.MarjarasanaCRight:
                 YogaPose = MarjarasanaCRight(result: self.result)
           
            case Pose.Navasana:
                 YogaPose = Navasana(result: self.result)
 
            case Pose.Padangushthasana:
                 YogaPose = Padangushthasana(result: self.result)
 
            case Pose.UrdhvaDhanurasana:
                 YogaPose = UrdhvaDhanurasana(result: self.result)

            case Pose.UtthitaParsvakonasanaALeft:
                 YogaPose = UtthitaParsvakonasanaALeft(result: self.result)
            case Pose.UtthitaParsvakonasanaARight:
                 YogaPose = UtthitaParsvakonasanaARight(result: self.result)

            case Pose.UtthitaParsvakonasanaBLeft:
                 YogaPose = UtthitaPashvakonasanaBLeft(result: self.result)
            case Pose.UtthitaParsvakonasanaBRight:
                 YogaPose = UtthitaPashvakonasanaBRight(result: self.result)
                
            case Pose.Utkatasana:
                 YogaPose = Utkatasana(result: self.result)
                
            case Pose.UrdhvaMukhaSvanasana:
                 YogaPose = UrdhvaMukhaSvanasana(result: self.result)
                
            case Pose.UtthitaTrikonasanaLeft:
                 YogaPose = UtthitaTrikonasanaLeft(result: self.result)
            case Pose.UtthitaTrikonasanaRight:
                 YogaPose = UtthitaTrikonasanaRight(result: self.result)
                
            case Pose.VirabhadrasanaALeft:
                 YogaPose = VirabhadrasanaALeft(result: self.result)
            case Pose.VirabhadrasanaARight:
                 YogaPose = VirabhadrasanaARight(result: self.result)
                
            case Pose.VirabhadrasanaBLeft:
                 YogaPose = VirabhadrasanaBLeft(result: self.result)
            case Pose.VirabhadrasanaBRight:
                 YogaPose = VirabhadrasanaBRight(result: self.result)
                
            case Pose.VirabhadrasanaCLeft:
                 YogaPose = VirabhadrasanaCLeft(result: self.result)
            case Pose.VirabhadrasanaCRight:
                 YogaPose = VirabhadrasanaCRight(result: self.result)
                
            case Pose.VirabhadrasanaDLeft:
                 YogaPose = VirabhadrasanaDLeft(result: self.result)
            case Pose.VirabhadrasanaDRight:
                 YogaPose = VirabhadrasanaDRight(result: self.result)

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
