//
//  CGPoint+.swift
//  MiPS
//
//  Created by 남유성 on 12/20/23.
//

import Foundation

extension CGPoint {
    func calSoundSource(of type: Instruments) -> SoundSource {
        
        let r = sqrt(Float(self.x * self.x + self.y * self.y))
        let theta = atan2(Float(self.y), Float(self.x)) * 180 / .pi
//        let phi = acos(Float(self.z) / r) * 180 / .pi
        let pi = Float(90)
        
        return SoundSource(type: type, theta: theta, pi: pi, r: r)
    }
}
