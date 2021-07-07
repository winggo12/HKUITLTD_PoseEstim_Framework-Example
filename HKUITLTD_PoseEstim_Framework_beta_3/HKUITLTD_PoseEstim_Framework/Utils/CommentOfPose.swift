//
//  CommentOfPose.swift
//  HKUITLTD_PoseEstim_Framework
//
//  Created by hkuit155 on 26/6/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import Foundation

public func comment(score: Double) -> String{

    if(score < 80){
        return " not ideal"
    }
    if(score == 80){
        return " is okay"
    }
    if(score > 80){
        return " is great"
    }

    else{
        return ""
    }
}
