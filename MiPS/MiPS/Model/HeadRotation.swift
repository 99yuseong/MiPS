//
//  HeadRotation.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/12.
//

import Foundation

class HeadRotation: Codable {
    var roll: Double
    var pitch: Double
    var yaw: Double
    
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
    
    func toJsonString() -> String? {
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(self),
              let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return nil
        }
        
        return jsonString
    }
}
