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
    let HopSize = FrameSize/2

    let HRIRNum = 10
    
    var HRIR: [[String]] = [[],[]]

    var c = [Float](repeating: 0, count: FrameSize)
    vDSP_hann_window(&c, n, Int32(vDSP_HANN_DENORM))

    class HRIR_L {
        let HRIR_Data: String
        init(HRIR_Data: String) {
            self.HRIR_Data = HRIR_Data
        }
    }

    let L_path = Bundle.main.path(forResource: "HRIR_L", ofType: "csv")!
    let importer_L = CSVImporter<HRIR_L>(path: L_path)

    importer_L.startImportingRecords { recordValues -> HRIR_L in
        return HRIR_L(HRIR_Data: recordValues[HRIRNum])
    }.onFinish { importedRecords in
        
        HRIR[0] = importedRecords.map{
            $0.HRIR_Data
        }
        
//        for HRIR_L_Data in importedRecords {
//            HRIR[0] = HRIR_L_Data.HRIR_Data
//        }
        
    }
    
    class HRIR_R {
        let HRIR_Data: String
        init(HRIR_Data: String) {
            self.HRIR_Data = HRIR_Data
        }
    }

    let R_path = Bundle.main.path(forResource: "HRIR_R", ofType: "csv")!
    let importer_R = CSVImporter<HRIR_R>(path: R_path)

    
    importer_R.startImportingRecords { recordValues -> HRIR_R in
            return HRIR_R(HRIR_Data: recordValues[HRIRNum])
        }.onFinish { importedRecords in
            
            HRIR[1] = importedRecords.map{
                $0.HRIR_Data
            }
            
    //        for HRIR_R_Data in importedRecords {
    //            HRIR[1] = HRIR_R_Data.HRIR_Data
    //        }
            
            
            
    } 
    
//    print(HRIR)
    
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
