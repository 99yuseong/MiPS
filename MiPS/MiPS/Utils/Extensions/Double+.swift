//
//  Double+.swift
//  MiPS
//
//  Created by 남유성 on 10/31/23.
//

import Foundation

extension Double {
    func toDegrees() -> Float {
        return Float(180 / .pi * self)
    }
}
