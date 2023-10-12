//
//  Float+.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/12.
//

import Foundation

extension Float {
    func roundToFirst() -> Float {
        (self * 10).rounded() / 10
    }
}
