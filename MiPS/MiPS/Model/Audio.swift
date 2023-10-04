//
//  Audio.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/04.
//

import Foundation
import AVFoundation

class Audio {
    let name: String
    let ext: AudioExt
    let type: Instrument

    private var frameCount: Int
    private var buffer: AVAudioPCMBuffer? = nil
    
    init(
        name: String,
        ext: AudioExt,
        type: Instrument,
        frameCount: Int = 1024
    ) {
        self.name = name
        self.ext = ext
        self.type = type
        self.frameCount = frameCount
        self.buffer = self.loadAudio()
    }
}

// MARK: - Method
extension Audio {
    
    /// floatArray를 1024 프레임으로 잘라 Index에 위치한 1024개의 [Float]을 리턴합니다.
    /// - Parameter index: 리턴할 [Float]의 순서
    /// - Returns: 1024 프레임의 [Float]
    public func floatArray(at index: Int) -> [Float] {
        
        guard let buffer = buffer else {
            print(#fileID, #function, #line, "⛔️ Buffer is Empty")
            return []
        }
        
        guard (index + 1) * frameCount < buffer.frameLength else {
            print(#fileID, #function, #line, "⛔️ Out of Index for Buffer")
            return []
        }
        
        let floatArray = UnsafeBufferPointer(
            // MARK: - Stereo의 경우 channel 0의 버퍼만 사용합니다.
            start: buffer.floatChannelData![0],
            count: Int(buffer.frameLength)
        )
        
        let start = index * frameCount
        let end = min((index + 1) * frameCount, Int(buffer.frameLength))
        
        return Array(floatArray[start..<end])
    }
    
    /// floatArray를 1024 프레임으로 잘랐을 때의 마지막 Index를 리턴합니다.
    /// - Returns: 최대 자를 수 있는 Index
    public func floatArrayMaxIndex() -> Int {
        
        guard let buffer = buffer else {
            print(#fileID, #function, #line, "⛔️ Buffer is Empty")
            return 0
        }
        
        print(buffer.frameLength)
        print(frameCount)
        
        return Int(Int(buffer.frameLength) / frameCount)
    }
}

// MARK: - Initialize Audio
extension Audio {
    
    private func loadAudio() -> AVAudioPCMBuffer? {
        guard let url = loadUrl(),
              let file = loadFile(for: url),
              let format = loadFormat(for: file),
              let buffer = loadBuffer(file: file, format: format)
        else { return nil }
        
        return buffer
    }
    
    private func loadBuffer(file: AVAudioFile, format: AVAudioFormat) -> AVAudioPCMBuffer? {

        guard let buffer = AVAudioPCMBuffer(
                pcmFormat: format,
                frameCapacity: UInt32(file.length)
              ),
              ((try? file.read(into: buffer)) != nil)
        else {
            print(#fileID, #function, #line, "⛔️ can't load audio buffer")
            return nil
        }
        
        return buffer
    }
    
    private func loadFormat(for file: AVAudioFile) -> AVAudioFormat? {
        guard let format = AVAudioFormat(
          commonFormat: .pcmFormatFloat32,
          sampleRate: file.fileFormat.sampleRate,
          channels: file.fileFormat.channelCount,
          interleaved: false
        ) else {
            print(#fileID, #function, #line, "⛔️ can't load audio format")
            return nil
        }
        
        return format
    }
    
    private func loadFile(for url: URL) -> AVAudioFile? {
        guard let file = try? AVAudioFile(forReading: url) else {
            print(#fileID, #function, #line, "⛔️ can't read audio file")
            return nil
        }
        
        return file
    }
    
    private func loadUrl() -> URL? {
        guard let url = Bundle.main.url(
            forResource: name,
            withExtension: ext.description
        ) else {
            print(#fileID, #function, #line, "⛔️ can't find audio file")
            return nil
        }
        
        return url
    }
}
