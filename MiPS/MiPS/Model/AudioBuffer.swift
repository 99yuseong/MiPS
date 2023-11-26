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
    var count: Int
    var left: [Float]
    var right: [Float]
    
    func toStereoBuffer() -> AVAudioPCMBuffer {
        let bufferSize = min(left.count, right.count)
        
        let format = AVAudioFormat(
            standardFormatWithSampleRate: 44100,
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
    
    static func decodeJsonToBuffer(_ jsonString: String) -> AudioBuffer? {
        let decoder = JSONDecoder()
        
        guard let jsonData = jsonString.data(using: .utf8),
              let audioBuffer = try? decoder.decode(self, from: jsonData)
        else { return nil }
        
        return audioBuffer
    }
    
    static func + (left: AudioBuffer, right: AudioBuffer) -> AudioBuffer {
        return AudioBuffer(
            index: min(left.index, right.index),
            count: left.count + right.count,
            left: left.left + right.left,
            right: left.right + right.right
        )
    }
}
