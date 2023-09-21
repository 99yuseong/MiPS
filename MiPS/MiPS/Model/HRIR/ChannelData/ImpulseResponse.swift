//
//  ImpulseResponse.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/21.
//

import Foundation
import CSVImporter

class ImpulseResponse {
    private var name: String
    private var format: Format
    private var path: String?
    
    private var source: [[Amplitude]] = []
    
    lazy var array: [[String]] = source.map { $0.map { $0.value } }
    
    init(
        name: String,
        format: Format,
        path: String? = nil
    ) {
        self.name = name
        self.format = format
        self.path = setPath()
        self.source = loadSource()
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
            print(name)
            print("Can't Find File Path")
            return []
        }
        
        let importer = CSVImporter<[Amplitude]>(path: path)
        
        return importer.importRecords { $0.map { Amplitude(value: $0) } }
    }
}
