//
//  HeadRotation.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/12.
//

import Foundation

class HeadRotation: Codable {
    var roll: Float
    var pitch: Float
    var yaw: Float
    
    init(roll: Float, pitch: Float, yaw: Float) {
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
}
