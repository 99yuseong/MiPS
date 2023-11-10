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
    
    func byteToFloat2DArray() -> [[Float]] {
        let byteSizeForOneArray = 512 * MemoryLayout<Float>.size
        
        let left = self.subdata(in: 0..<byteSizeForOneArray)
        let right = self.subdata(in: byteSizeForOneArray..<self.count)
        
        return [left.byteToFloatArray(), right.byteToFloatArray()]
    }
}
