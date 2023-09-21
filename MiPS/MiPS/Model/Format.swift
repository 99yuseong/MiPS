//
//  AudioFormat.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation

protocol Format: CustomStringConvertible {}

enum AudioFormat: String, Format {
    var description: String { self.rawValue }
    
    case mp3 = "mp3"
}

enum DataFormat: String, Format {
    var description: String { self.rawValue }
    
    case csv = "csv"
}

