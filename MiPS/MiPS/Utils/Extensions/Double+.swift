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
    
    func roundToFirst() -> Double {
        (self * 10).rounded() / 10
    }
}
