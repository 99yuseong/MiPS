//
//  FileExt.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation

protocol FileExt: CustomStringConvertible {}

enum AudioExt: String, FileExt {
    var description: String { self.rawValue }
    
    case mp3 = "mp3"
}

enum DataExt: String, FileExt {
    var description: String { self.rawValue }
    
    case csv = "csv"
}
