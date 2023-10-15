//
//  Data+.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/12.
//

import Foundation

extension Data {
    func byteToFloatArray() -> [Float] {
        self.withUnsafeBytes { Array($0.bindMemory(to: Float.self)) }
    }
}
