//
//  YogaBase.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 5/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

class YogaBase {
    
    /** Output */
    public var comment: Array<String>? = nil
    public var score: Double? = nil
    public var detailedscore: Array<Double>? = nil
    public var colorbit: Array<Character>? = nil
    
    /** Input */
    public var result: Result? = nil
    public var resultArray: Array<Array<Double>>? = nil
    
    /** Getter */
    public func getScore()-> Double { return self.score! }
    public func getComment()-> Array<String> { return self.comment! }
    public func getResult()-> Result { return self.result! }
    public func getDetailedScore()-> Array<Double>{return detailedscore!}
    public func getColorBit()->Array<Character>{return colorbit!}
    
}
