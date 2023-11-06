//
//  HPMotionService.swift
//  MiPS
//
//  Created by 남유성 on 10/31/23.
//

import Foundation
import CoreMotion

protocol HPMotionDelegate: NSObjectProtocol {
    func isHeadPhoneAvailable(_ available: Bool)
    func didHeadPhoneConnected()
    func didHeadPhoneDisconnected()
    func didHeadPhoneMotionUpdated(_ headRotation: HeadRotation)
}

class HPMotionService: NSObject {
    
    static let shared = HPMotionService()
    
    weak var delegate: HPMotionDelegate?
    
    private let manager = CMHeadphoneMotionManager()

    private override init() {
        super.init()
        manager.delegate = self
        startUpdate()
    }
    
    deinit {
        stopUpdate()
    }
}

extension HPMotionService {
    private func startUpdate() {
        guard isDeviceMotionAvailable()
        else { alert("Device not Supported"); return }
        
        startDeviceMotionUpdates()
    }
    
    private func stopUpdate() {
        manager.stopDeviceMotionUpdates()
    }
    
    private func isDeviceMotionAvailable() -> Bool {
        let available: Bool = manager.isDeviceMotionAvailable
        delegate?.isHeadPhoneAvailable(available)
        
        return available
    }
    
    private func startDeviceMotionUpdates() {
        manager.startDeviceMotionUpdates(to: OperationQueue.current!) { [weak self] deviceMotion, error in
            
            guard
                let self = self,
                let att = deviceMotion?.attitude
            else {
                self?.alert(error!.localizedDescription); return
            }
            
            let headRotation = HeadRotation(
                roll: att.roll,
                pitch: att.pitch,
                yaw: att.yaw
            )
            
            self.delegate?.didHeadPhoneMotionUpdated(headRotation)
        }
    }
}

extension HPMotionService: CMHeadphoneMotionManagerDelegate {
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        delegate?.didHeadPhoneConnected()
        
        alert("AirPods Connected")
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        delegate?.didHeadPhoneDisconnected()
        
        alert("AirPods Disconnected!")
    }
}


extension HPMotionService {
    private func alert(_ message: String) {
        print("[HPMotionService] \(message)")
    }
}
