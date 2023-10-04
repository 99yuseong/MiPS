//
//  Instrument.swift
//  MiPS
//
//  Created by 남유성 on 2023/10/03.
//

import Foundation
import AVFoundation

enum Instrument: String, CustomStringConvertible, CaseIterable {
    var description: String { self.rawValue }
    
    case guitar = "guitar"
    case piano = "piano"
    case unknown
    
    static func toType(of path: String) -> Instrument {
        
        for i in self.allCases {
            if i.description == path { return i }
        }
        
        return .unknown
    }
}
