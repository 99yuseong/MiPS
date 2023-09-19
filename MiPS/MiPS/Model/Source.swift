//
//  Source.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/20.
//

import Foundation

class Source {
    let name: String
    let format: AudioFormat
    let url: String
    
    init(name: String, format: AudioFormat, url: String) {
        self.name = name
        self.format = format
        self.url = url
    }
}

struct DefaultSource {
    static let soundHelix = Source(
        name: "soundhelix",
        format: .mp3,
        url: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
}
