//
//  MiPSPlayer.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/03.
//

import Foundation
import Accelerate
import AVFoundation

class MiPSPlayer {
    
    private let sampleRate: Double = 44100
    private let channels: AVAudioChannelCount = 2
    
    private let audioEngine = AVAudioEngine()
    private let playerNode = AVAudioPlayerNode()
    private let audio: Audio

    let FS = 44100
    let FrameSize = 1024
    let HRIRNum = 10
    
    let n: UInt
    let HopSize: Int
    
    let HRIR_L: [Float]
    let HRIR_R: [Float]
    let reversedHRIR_L: [Float]
    let reversedHRIR_R: [Float]
    
    var ibuffer: [Float]
    var obuffer_L: [Float]
    var obuffer_R: [Float]
    
    init(audio: Audio) {
        self.audio = audio
        
        n = vDSP_Length(FrameSize)
        HopSize = FrameSize / 2
        HRIR_L = HRIR.data.left(at: HRIRNum)
        HRIR_R = HRIR.data.right(at: HRIRNum)
        reversedHRIR_L = Array(HRIR_L.reversed())
        reversedHRIR_R = Array(HRIR_R.reversed())
        
        print(#fileID, #function, #line, "\(HRIR_L.max()), \(HRIR_L.min())")
        
        ibuffer = [Float] (repeating:0, count: FrameSize)
        obuffer_L = [Float] (repeating: 0, count: FS + FrameSize)
        obuffer_R = [Float] (repeating: 0, count: FS + FrameSize)
        
        self.prepareEngine()
    }
    
    private func prepareEngine() {
        audioEngine.attach(playerNode)
        audioEngine.connect(
            playerNode, to: audioEngine.mainMixerNode, format: nil
        )
        
        do {
            try audioEngine.start()
        } catch {
            print(#fileID, #function, #line, "⛔️ Failed to start engine: \(error)")
        }
    }
    
    func play(bufferData: [[Float]]) -> AVAudioPCMBuffer {
        let format = AVAudioFormat(
            standardFormatWithSampleRate: sampleRate,
            channels: channels
        )!
        
        let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: UInt32(bufferData[0].count)
        )!
        
        buffer.frameLength = buffer.frameCapacity

        let left = bufferData[0]
        let right = bufferData[1]
        
        for i in 0..<bufferData[0].count {
            buffer.floatChannelData?[0][i] = left[i]
            buffer.floatChannelData?[1][i] = right[i]
        }

        return buffer
    }
    
    func play(idx: Int) {
        guard idx < audio.floatArrayMaxIndex() else { return }
        
        justPlay(idx: idx, interval: 5)
//        justPlayOriginal(idx: idx, interval: 1)
    }
    
    func justPlayOriginal(idx: Int, interval: Int) {
        for i in 0..<interval {
            self.stackQueue(array: [audio.floatArray(at: idx + i), audio.floatArray(at: idx + i)])
        }
        
        let buffer = play(bufferData: [audio.floatArray(at: idx + interval), audio.floatArray(at: idx + interval)])
        
        self.playerNode.scheduleBuffer(buffer) {
            self.justPlayOriginal(idx: idx + interval + 1, interval: interval)
        }
    }
    
    func justPlay(idx: Int, interval: Int) {
        for i in 0..<interval {
            stackQueue(array: transfer(floatArray: audio.floatArray(at: idx + i)))
        }
    
        let buffer = play(bufferData: transfer(floatArray: audio.floatArray(at: idx + interval)))

        self.playerNode.scheduleBuffer(buffer) {
            self.justPlay(idx: idx + interval + 1, interval: interval)
        }
    }
    
    func stackQueue(array: [[Float]]) {
        let buffer = play(bufferData: array)
        self.playerNode.scheduleBuffer(buffer)
    }
}

extension MiPSPlayer {
    public func play() {
        self.play(idx: 0)
        playerNode.play()
    }
    
    public func transfer(floatArray: [Float]) -> [[Float]] {
        return [floatArray, floatArray]
    }
}
