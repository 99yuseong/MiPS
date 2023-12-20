//
//  SoundSource.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/12.
//

import Foundation

class SoundSource: Codable {
    var type: String
    var theta: Float
    var pi: Float
    var r: Float
    
    init(type: Instruments, theta: Float, pi: Float, r: Float) {
        self.type = type.rawValue
        self.theta = theta
        self.pi = pi
        self.r = r
    }
}
