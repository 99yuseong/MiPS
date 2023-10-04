//
//  HeaderPositioning.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/21.
//

import Foundation
import CSVImporter

class HeaderPositioning {
    private var name: String
    private var format: FileExt
    private var path: String?
    
    private var source: [SpcCoordinate] = []
    
    lazy var array: [SpcCoordinate] = source.map { $0 }
    
    init(
        name: String,
        format: FileExt,
        path: String? = nil
    ) {
        self.name = name
        self.format = format
        self.path = setPath()
        self.source = loadSource()
    }
}

// MARK: - initialize
extension HeaderPositioning {
    private func setPath() -> String? {
        Bundle.main.path(
            forResource: name,
            ofType: format.description
        )
    }
    
    private func loadSource() -> [SpcCoordinate] {
        guard let path = path else {
            print("Can't Find File Path")
            return []
        }
        
        let importer = CSVImporter<SpcCoordinate>(path: path)
        return importer.importRecords { importedRecords in
            
            let theta = Float(importedRecords[0])!
            let pi = Float(importedRecords[1])!
            let r = Float(importedRecords[2])!
            
            return SpcCoordinate(theta: theta, pi: pi, r: r)
        }
    }
}
