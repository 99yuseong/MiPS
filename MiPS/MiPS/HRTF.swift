//
//  HRTF.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation
import Accelerate
import CSVImporter

func soundSourcePositioning() {
    let FS = 44100

    let FrameSize = 1024
    let n = vDSP_Length(FrameSize)
    let HopSize = FrameSize/2
    let NHop = FrameSize/HopSize

    let HRIRNum = 10

    var c = [Float](repeating: 0, count: FrameSize)
    vDSP_hann_window(&c, n, Int32(vDSP_HANN_DENORM))

    class HRIR_L {
        let HRIR_Data: String
        init(HRIR_Data: String) {
            self.HRIR_Data = HRIR_Data
        }
    }

    let L_path = Bundle.main.path(forResource: "HRIR_L", ofType: "csv")!
    let importer = CSVImporter<HRIR_L>(path: L_path)

    importer.startImportingRecords { recordValues -> HRIR_L in
        return HRIR_L(HRIR_Data: recordValues[HRIRNum])
    }.onFinish { importedRecords in
        
        for HRIR_L_Data in importedRecords {
            print(HRIR_L_Data.HRIR_Data)
        }
    }
}
