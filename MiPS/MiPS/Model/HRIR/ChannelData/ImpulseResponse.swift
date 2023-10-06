//
//  ImpulseResponse.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/21.
//

import Foundation
import CSVImporter

class ImpulseResponse {
    private let name: String
    private let format: FileExt
    private var path: String?
    
    private var source: [[Amplitude]] = []
    
    lazy var array: [[String]] = source.map { $0.map { $0.value } }
    
    init(
        name: String,
        format: FileExt
    ) {
        self.name = name
        self.format = format
        self.path = setPath()
        self.source = loadSource()
//        print(#fileID, #function, #line, "\()")
    }
}

// MARK: - initialize
extension ImpulseResponse {
    private func setPath() -> String? {
        Bundle.main.path(
            forResource: name,
            ofType: format.description
        )
    }
    
    private func loadSource() -> [[Amplitude]] {
        guard let path = path else {
            print("Can't Find File Path")
            return []
        }
        
        let importer = CSVImporter<[Amplitude]>(path: path)
        
        return importer.importRecords { $0.map { Amplitude(value: $0) } }
    }
}
