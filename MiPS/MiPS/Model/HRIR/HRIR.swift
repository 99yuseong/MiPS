//
//  SoundPositioningService.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/21.
//

import Foundation
import AVFoundation

protocol HRIRProtocol {
    func left(at index: Int) -> [Float]
    func right(at index: Int) -> [Float]
    func positioning(at index: Int) -> SpcCoordinate
}

/// Resource/HRTF_DATA 경로에 저장된 .scv 파일에서 데이터를 추출한 클래스입니다.
///
/// HRIR.data.left(at: index)를 통해 [Double] 데이터를 얻을 수 있습니다.
/// HRIR.data.left(at: index) 역시 동일합니다.
///
///     HRIR.data.left(at: HRIRNum)
///
///     HRIR.data.right(at: HRIRNum)
///
/// HRIR.data.positioning(at: index)를 통해 각 index의 theta, pi, r의 Float 값을 얻을 수 있습니다.
///
///     HRIR.data.positioning(at: HRIRNum).theta
///
///     HRIR.data.positioning(at: HRIRNum).pi
///
///     HRIR.data.positioning(at: HRIRNum).r
///
class HRIR: HRIRProtocol {
    
    static let data = HRIR(
        left: "HRIR_L",
        right: "HRIR_R",
        positioning: "SourcePosition"
    )
    
    private let left: ImpulseResponse
    private let right: ImpulseResponse
    private let positioning: HeaderPositioning
    
    private init(
        left: String,
        right: String,
        positioning: String
    ) {
        self.left = ImpulseResponse(
            name: left,
            format: DataExt.csv
        )
        self.right = ImpulseResponse(
            name: right,
            format: DataExt.csv
        )
        self.positioning = HeaderPositioning(
            name: positioning,
            format: DataExt.csv
        )
    }
}

// MARK: - Methods
extension HRIR {
    /// HRIR Left 데이터의 index번째 위치한 Float 배열을 리턴합니다.
    /// - Parameter index: 조회할 데이터의 순번
    /// - Returns: Amplitude Float 배열
    public func left(at index: Int) -> [Float] {
        guard index >= 0,
              index < left.array.count
        else {
            print("⛔️ HRIR_Left Out of Range")
            return []
        }
        
        return left.array[index].map { Float($0) ?? 0 }
    }
    
    /// HRIR Right 데이터의 index번째 위치한 Float 배열을 리턴합니다.
    /// - Parameter index: 조회할 데이터의 순번
    /// - Returns: Amplitude Float 배열
    public func right(at index: Int) -> [Float] {
        guard index >= 0,
              index < right.array.count
        else {
            print("⛔️ HRIR_Right Out of Range")
            return []
        }
        
        return right.array[index].map { Float($0) ?? 0 }
    }
    
    /// HRIR Positioning 데이터의 index번째 위치한 SpcCoordinate을 리턴합니다.
    /// - Parameter index: 조회할 데이터의 순번
    /// - Returns: theta, pi, r의 Float 값
    public func positioning(at index: Int) -> SpcCoordinate {
        guard index >= 0,
              index < positioning.array.count
        else {
            print("⛔️ HRIR_Positioning Out of Range")
            return SpcCoordinate(theta: 0, pi: 0, r: 0)
        }
        
        return positioning.array[index]
    }
}
