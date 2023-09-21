//
//  HRTF.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation
import Accelerate
import CSVImporter
import AVFoundation


func soundSourcePositioning() {

    let FrameSize = 1024
    let n = vDSP_Length(FrameSize)
    let HopSize = FrameSize / 2
    let HRIRNum = 10
    var c = [Float](repeating: 0, count: FrameSize)

    vDSP_hann_window(&c, n, Int32(vDSP_HANN_DENORM))
    
    let HRIRData = HRIR(
        left: "HRIR_R",
        right: "HRIR_R",
        positioning: "SourcePosition"
    )
    
    let HRIR_L = HRIRData.left.array[HRIRNum]
    let HRIR_R = HRIRData.right.array[HRIRNum]
    let HRIR_Positioning = HRIRData.positioning.array[HRIRNum]

    print("HRIR_L: \(HRIR_L)")
    print("HRIR_R: \(HRIR_R)")
    print("HRIR_Positioning: \(HRIR_Positioning)")
    print("theta: \(HRIR_Positioning.theta)")
    print("pi: \(HRIR_Positioning.pi)")
    print("r: \(HRIR_Positioning.r)")

    if let url = Bundle.main.url(forResource: "soundhelix", withExtension: "mp3") {

        let file = try! AVAudioFile(forReading: url)

        if let format = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: file.fileFormat.sampleRate, channels: 2, interleaved: false) {

            if let buf = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: 1024) {

                try! file.read(into: buf)

                // this makes a copy, you might not want that
                let floatArray = UnsafeBufferPointer(start: buf.floatChannelData![0], count:Int(buf.frameLength))
                // convert to data

                var data = Data()

                for buf in floatArray {
                    data.append(withUnsafeBytes(of: buf) { Data($0) })
                }
                // use the data if required.


            }
        }
    }
}

