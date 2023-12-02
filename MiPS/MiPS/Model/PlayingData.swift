//
//  PlayingData.swift
//  MiPS
//
//  Created by 남유성 on 12/1/23.
//

import Foundation

struct PlayingData: Codable {
    var headRotation: HeadRotation
    var curIndex: Int
    
    func toJsonString() -> String? {
        let encoder = JSONEncoder()
        
        guard let jsonData = try? encoder.encode(self),
              let jsonString = String(data: jsonData, encoding: .utf8)
        else {
            return nil
        }
        
        return jsonString
    }
}
