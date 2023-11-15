//
//  AudioBuffer.swift
//  MiPS
//
//  Created by 남유성 on 11/10/23.
//

import Foundation
import AVFoundation

struct AudioBuffer: Codable {
    var index: Int
    var left: [Float]
    var right: [Float]
    
    func toStereoBuffer(rate: Double = 44100) -> AVAudioPCMBuffer {
        let bufferSize = min(left.count, right.count)
        
        let format = AVAudioFormat(
            standardFormatWithSampleRate: rate,
            channels: 2
        )!
        
        let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: UInt32(bufferSize)
        )!
        
        buffer.frameLength = buffer.frameCapacity
        
        for i in 0..<bufferSize {
            buffer.floatChannelData?[0][i] = left[i]
            buffer.floatChannelData?[1][i] = right[i]
        }

        return buffer
    }
}
