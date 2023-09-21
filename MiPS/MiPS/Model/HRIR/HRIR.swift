//
//  SoundPositioningService.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/21.
//

import Foundation

/// Resource/HRTF_DATA 경로에 저장된 .scv 파일에서 데이터를 추출한 클래스입니다.
///
/// left.array[index]를 통해 [String] 데이터를 얻을 수 있습니다.
/// right.array[index] 역시 동일합니다.
///
///     left.array[0]
///
///     right.array[10]
///
/// positioning.array[index]를 통해 각 index의 theta, pi, r의 Float 값을 얻을 수 있습니다.
///
///     positioning.array[index].theta
///
///     positioning.array[index].pi
///
///     positioning.array[index].r
///
class HRIR {
    
    var left: ImpulseResponse
    var right: ImpulseResponse
    var positioning: HeaderPositioning
    
    init(
        left: String,
        right: String,
        positioning: String
    ) {
        self.left = ImpulseResponse(
            name: left,
            format: DataFormat.csv
        )
        self.right = ImpulseResponse(
            name: right,
            format: DataFormat.csv
        )
        self.positioning = HeaderPositioning(
            name: positioning,
            format: DataFormat.csv
        )
    }
}
