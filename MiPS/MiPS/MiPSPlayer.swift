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
    
    lazy var ibuffer = [Float] (repeating:0, count: FrameSize)
    lazy var obuffer_L = [Float] (repeating: 0, count: FS + FrameSize)
    lazy var obuffer_R = [Float] (repeating: 0, count: FS + FrameSize)
    
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

        let defaultArray1 = audio.floatArray(at: idx)
        let newFloatArray1 = transfer(
            floatArray: defaultArray1,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray2 = audio.floatArray(at: idx + 1)
        let newFloatArray2 = transfer(
            floatArray: defaultArray2,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray3 = audio.floatArray(at: idx + 2)
        let newFloatArray3 = transfer(
            floatArray: defaultArray3,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray4 = audio.floatArray(at: idx + 3)
        let newFloatArray4 = transfer(
            floatArray: defaultArray4,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray5 = audio.floatArray(at: idx + 4)
        let newFloatArray5 = transfer(
            floatArray: defaultArray5,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray6 = audio.floatArray(at: idx + 5)
        let newFloatArray6 = transfer(
            floatArray: defaultArray6,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray7 = audio.floatArray(at: idx + 6)
        let newFloatArray7 = transfer(
            floatArray: defaultArray7,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray8 = audio.floatArray(at: idx + 7)
        let newFloatArray8 = transfer(
            floatArray: defaultArray8,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray9 = audio.floatArray(at: idx + 8)
        let newFloatArray9 = transfer(
            floatArray: defaultArray9,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray10 = audio.floatArray(at: idx + 9)
        let newFloatArray10 = transfer(
            floatArray: defaultArray10,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray11 = audio.floatArray(at: idx + 10)
        let newFloatArray11 = transfer(
            floatArray: defaultArray11,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let defaultArray12 = audio.floatArray(at: idx + 11)
        let newFloatArray12 = transfer(
            floatArray: defaultArray12,
            FrameSize: FrameSize,
            HRIRNum: HRIRNum
        )
        
        let buffer1 = play(bufferData: newFloatArray1)
        let buffer2 = play(bufferData: newFloatArray2)
        let buffer3 = play(bufferData: newFloatArray3)
        let buffer4 = play(bufferData: newFloatArray4)
        let buffer5 = play(bufferData: newFloatArray5)
        let buffer6 = play(bufferData: newFloatArray6)
        let buffer7 = play(bufferData: newFloatArray7)
        let buffer8 = play(bufferData: newFloatArray8)
        let buffer9 = play(bufferData: newFloatArray9)
        let buffer10 = play(bufferData: newFloatArray10)
        let buffer11 = play(bufferData: newFloatArray11)
        let buffer12 = play(bufferData: newFloatArray12)

        self.playerNode.scheduleBuffer(buffer1)
        self.playerNode.scheduleBuffer(buffer2)
        self.playerNode.scheduleBuffer(buffer3)
        self.playerNode.scheduleBuffer(buffer4)
        self.playerNode.scheduleBuffer(buffer5)
        self.playerNode.scheduleBuffer(buffer6)
        self.playerNode.scheduleBuffer(buffer7)
        self.playerNode.scheduleBuffer(buffer8)
        self.playerNode.scheduleBuffer(buffer9)
        self.playerNode.scheduleBuffer(buffer10)
        self.playerNode.scheduleBuffer(buffer11)
        self.playerNode.scheduleBuffer(buffer12) {
            self.play(idx: idx + 12)
        }
    }
}

extension MiPSPlayer {
    public func play() {
        self.play(idx: 0)
        playerNode.play()
    }
    
    public func transfer(floatArray: [Float], FrameSize: Int, HRIRNum: Int) -> [[Float]] {
        // MARK: - floatArray is constant. Which is default value
        
        // TODO: - You can change value of newFloatArray which is copy of float Array
        let n = vDSP_Length(FrameSize)
        let HopSize = FrameSize / 2
        
        // MARK: - HRIR Data
        let HRIR_L: [Double] = HRIR.data.left(at: HRIRNum)
        let HRIR_R: [Double] = HRIR.data.right(at: HRIRNum)
//        let HRIR_Positioning: SpcCoordinate = HRIR.data.positioning(at: HRIRNum)
        
//        print("HRIR_L: \(HRIR_L)")
//        print("HRIR_R: \(HRIR_R)")
//        print("theta: \(HRIR_Positioning.theta)")
//        print("pi: \(HRIR_Positioning.pi)")
//        print("r: \(HRIR_Positioning.r)")
        
        // TODO: - 여기서 변환을 해주세용
        
//        var ibuffer = ibuffer
//        var obuffer_L = obuffer_L
//        var obuffer_R = obuffer_R
        var newFloatArray = [[Float]]()
        
        self.ibuffer += floatArray
        var ibufferInst = ibuffer[HopSize...]
        self.ibuffer = Array(ibufferInst)
        
        var dataIn = ibuffer
        vDSP_hann_window(&dataIn, n, Int32(vDSP_HANN_DENORM))
        
        let dataSize = dataIn.count
        let HRIRSize = HRIR_L.count
        
        var paddedSignal = dataIn + Array(repeating: 0.0, count: HRIRSize - 1)
        var dataHRTF_L = Array<Float>(repeating: 0.0, count: dataSize+HRIRSize - 1)
        
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
        
        newFloatArray = [outL, outR]
        
        self.obuffer_L = Array(obuffer_L[HopSize...])
        self.obuffer_L += Array(repeating: 0, count: HopSize)
        
        self.obuffer_R = Array(obuffer_R[HopSize...])
        self.obuffer_R += Array(repeating: 0, count: HopSize)
        
        return newFloatArray
    }
}
