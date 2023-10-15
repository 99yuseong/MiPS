//
//  SoundSource.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/12.
//

import Foundation

class SoundSource: Codable {
    var theta: Float
    var pi: Float
    
    init(theta: Float, pi: Float) {
        self.theta = theta
        self.pi = pi
    }
}
