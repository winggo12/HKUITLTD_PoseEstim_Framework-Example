//
//  ColorbitUtilities.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 4/1/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

var score_thresh: Double = 80
class ColorFeedbackUtilities {

    public func left_arm(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1110000000000
        }
        return pose_bit
    }

    public func right_arm(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1000110000000
        }
        return pose_bit
    }
    
    public func left_leg(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1000000001100
        }
        return pose_bit
    }

    public func right_leg(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1000000000011
        }
        return pose_bit
    }

    public func left_shoulder(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1011000000000
        }
        return pose_bit
    }

    public func right_shoulder(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1001100000000
        }
        return pose_bit
    }
    
    public func left_waist(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1010001000000
        }
        return pose_bit
    }

    public func right_waist(score: Double) -> UInt{
        var pose_bit: UInt = 0b1000000000000
        if (score < score_thresh) {
            pose_bit = 0b1000100010000
        }
        return pose_bit
    }
    
    public func uint_to_array(colorbitmerge: UInt) -> Array<Character>{
        
        let colorbitmergeString = String(colorbitmerge, radix: 2)
        let intForIndex = 1
        let index = colorbitmergeString.index(colorbitmergeString.startIndex, offsetBy: intForIndex)
        let colorbit = Array(colorbitmergeString.substring(from: index))
        
        return colorbit
    }
    
}
