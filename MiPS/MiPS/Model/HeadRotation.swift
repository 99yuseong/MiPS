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
    
//    init(roll: Float, pitch: Float, yaw: Float) {
//        self.roll = roll.roundToFirst()
//        self.pitch = pitch.roundToFirst()
//        self.yaw = yaw.roundToFirst()
//    }
    
    init(roll: Double, pitch: Double, yaw: Double) {
        self.roll = roll.toDegrees().roundToFirst()
        self.pitch = pitch.toDegrees().roundToFirst()
        self.yaw = yaw.toDegrees().roundToFirst()
    }
}

extension HeadRotation: Equatable {
    static func == (lhs: HeadRotation, rhs: HeadRotation) -> Bool {
        return
            lhs.roll == rhs.roll &&
            lhs.pitch == rhs.pitch &&
            lhs.yaw == rhs.yaw
    }
}
