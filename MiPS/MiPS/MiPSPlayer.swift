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
    
    //
    let FS = 44100
    let FrameSize = 1024
    let HRIRNum = 10
    
    lazy var ibuffer = [Float] (repeating:0, count:FrameSize)
    lazy var obuffer_L = [Float] (repeating: 0, count: FS+FrameSize)
    lazy var obuffer_R = [Float] (repeating: 0, count: FS+FrameSize)
    //
    
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
    
    func play(bufferData: [[Float]]) -> AVAudioPCMBuffer {
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
            buffer.floatChannelData?.pointee[i] = bufferData[0][i]
            buffer.floatChannelData?.pointee[i] = bufferData[1][i]
        }

        return buffer
    }
    
    func play(idx: Int) {
        guard idx < audio.floatArrayMaxIndex() else { return }

        let defaultArray = audio.floatArray(at: idx)
        let newFloatArray = transfer(floatArray: defaultArray, ibuffer: ibuffer, obuffer_L: obuffer_L, obuffer_R: obuffer_R, FrameSize: FrameSize, HRIRNum: HRIRNum)
        
        let buffer = play(bufferData: newFloatArray)

        self.playerNode.scheduleBuffer(buffer) {
            self.play(idx: idx + 1)
            print("🤗 일단 1024프레임 1번만")
        }
    }
}

extension MiPSPlayer {
    public func play() {
        self.play(idx: 0)
        playerNode.play()
    }
    
    public func transfer(floatArray: [Float], ibuffer: [Float], obuffer_L: [Float], obuffer_R: [Float], FrameSize: Int, HRIRNum: Int) -> [[Float]] {
        // MARK: - floatArray is constant. Which is default value
        
        // TODO: - You can change value of newFloatArray which is copy of float Array
        let n = vDSP_Length(FrameSize)
        let HopSize = FrameSize / 2
        
        // MARK: - HRIR Data
        let HRIR_L: [Double] = HRIR.data.left(at: HRIRNum)
        let HRIR_R: [Double] = HRIR.data.right(at: HRIRNum)
        let HRIR_Positioning: SpcCoordinate = HRIR.data.positioning(at: HRIRNum)
        
//        print("HRIR_L: \(HRIR_L)")
//        print("HRIR_R: \(HRIR_R)")
//        print("theta: \(HRIR_Positioning.theta)")
//        print("pi: \(HRIR_Positioning.pi)")
//        print("r: \(HRIR_Positioning.r)")
        
        // TODO: - 여기서 변환을 해주세용
        
        var ibuffer = ibuffer
        var obuffer_L = obuffer_L
        var obuffer_R = obuffer_R
        var newFloatArray = [[Float]]()
        
        ibuffer += floatArray
        var ibufferInst = ibuffer[HopSize...]
        ibuffer = Array(ibufferInst)
        
        var dataIn = ibuffer
        vDSP_hann_window(&dataIn, n, Int32(vDSP_HANN_DENORM))
        
        let dataSize = dataIn.count
        let HRIRSize = HRIR_L.count
        
        var paddedSignal = dataIn + Array(repeating: 0.0, count: HRIRSize-1)
        var dataHRTF_L = Array<Float>(repeating: 0.0, count: dataSize+HRIRSize-1)
        
        var reversedHRIR_L = Array(HRIR_L.reversed()).map{Float($0)}
        vDSP_conv(paddedSignal, 1, reversedHRIR_L, 1, &dataHRTF_L, 1, vDSP_Length(dataSize+HRIRSize-1), vDSP_Length(HRIRSize))
        
        var dataHRTF_R = Array<Float>(repeating: 0.0, count: dataSize+HRIRSize-1)
        var reversedHRIR_R = Array(HRIR_R.reversed()).map{Float($0)}
        vDSP_conv(paddedSignal, 1, reversedHRIR_R, 1, &dataHRTF_R, 1, vDSP_Length(dataSize+HRIRSize-1), vDSP_Length(HRIRSize))
        
        for i in stride(from: 0, to: dataHRTF_L.count, by: 1) {
            obuffer_L[i] = obuffer_L[i] + dataHRTF_L[i]
            obuffer_R[i] = obuffer_R[i] + dataHRTF_R[i]
        }
        
        var outL = Array(obuffer_L[0...(HopSize-1)])
        var outR = Array(obuffer_R[0...(HopSize-1)])
    
//        var newFloatArray = [outL, outR]
        
        obuffer_L = Array(obuffer_L[HopSize...])
        obuffer_L += Array(repeating: 0, count: HopSize)
        
        obuffer_R = Array(obuffer_R[HopSize...])
        obuffer_R += Array(repeating: 0, count: HopSize)
        

        return newFloatArray
    }
}
