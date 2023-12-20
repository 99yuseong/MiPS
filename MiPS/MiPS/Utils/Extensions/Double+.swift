//
//  Double+.swift
//  MiPS
//
//  Created by 남유성 on 10/31/23.
//

import Foundation

extension Double {
    func toDegrees() -> Double {
        return self * 180 / .pi
    }
    
    func toRadians() -> Double {
        return self * .pi / 180
    }
    
    func roundToFirst() -> Double {
        (self * 10).rounded() / 10
    }
}
