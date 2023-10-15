//
//  Array+.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/12.
//

import Foundation
import AVFoundation

extension Array where Element == [Float] {
    func toStereoBuffer(rate: Double = 44100) -> AVAudioPCMBuffer {
        let format = AVAudioFormat(
            standardFormatWithSampleRate: rate,
            channels: 2
        )!
        
        let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: UInt32(self[0].count)
        )!
        
        buffer.frameLength = buffer.frameCapacity

        let left = self[0]
        let right = self[1]
        
        for i in 0..<self[0].count {
            buffer.floatChannelData?[0][i] = left[i]
            buffer.floatChannelData?[1][i] = right[i]
        }

        return buffer
    }
}
