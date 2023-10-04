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
        
    init(audio: Audio) {
        self.audio = audio
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
    
    func play(bufferData: [Float]) -> AVAudioPCMBuffer {
        let format = AVAudioFormat(
            standardFormatWithSampleRate: sampleRate,
            channels: channels
        )!
        
        let buffer = AVAudioPCMBuffer(
            pcmFormat: format,
            frameCapacity: UInt32(bufferData.count)
        )!

        buffer.frameLength = buffer.frameCapacity

        for i in 0..<bufferData.count {
            buffer.floatChannelData?.pointee[i] = bufferData[i]
        }

        return buffer
    }
    
    func play(idx: Int) {
        guard idx < audio.floatArrayMaxIndex() else { return }

        let defaultArray = audio.floatArray(at: idx)
        let newFloatArray = transfer(floatArray: defaultArray)
        
        let buffer = play(bufferData: newFloatArray)

        self.playerNode.scheduleBuffer(buffer) {
//            self.play(idx: idx + 1)
            print("🤗 일단 1024프레임 1번만")
        }
    }
}

extension MiPSPlayer {
    public func play() {
        self.play(idx: 0)
        playerNode.play()
    }
    
    public func transfer(floatArray: [Float]) -> [Float] {
        // MARK: - floatArray is constant. Which is default value
        
        // TODO: - You can change value of newFloatArray which is copy of float Array
        var newFloatArray = floatArray
        
        
        let FrameSize = 1024
        let n = vDSP_Length(FrameSize)
        let HopSize = FrameSize / 2
        let HRIRNum = 10
        var c = [Float](repeating: 0, count: FrameSize)
        
        vDSP_hann_window(&c, n, Int32(vDSP_HANN_DENORM))
        
        // MARK: - HRIR Data
        let HRIR_L: [Double] = HRIR.data.left(at: HRIRNum)
        let HRIR_R: [Double] = HRIR.data.right(at: HRIRNum)
        let HRIR_Positioning: SpcCoordinate = HRIR.data.positioning(at: HRIRNum)
        
        print("HRIR_L: \(HRIR_L)")
        print("HRIR_R: \(HRIR_R)")
        print("theta: \(HRIR_Positioning.theta)")
        print("pi: \(HRIR_Positioning.pi)")
        print("r: \(HRIR_Positioning.r)")
        
        // TODO: - 여기서 변환을 해주세용
        
        return newFloatArray
    }
}
