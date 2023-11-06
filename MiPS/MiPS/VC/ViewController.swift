//
//  ViewController.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/19.
//

import UIKit
import SnapKit
import Then
import AVFoundation
import SpriteKit

final class ViewController: UIViewController {
    
    // MARK: - UI
    private var rollLabel = UILabel().then {
        $0.text = "Roll: 0.0"
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    
    private var pitchLabel = UILabel().then {
        $0.text = "Pitch: 0.0"
        $0.font = UIFont.systemFont(ofSize: 10)
    }
        
    private var yawLabel = UILabel().then {
        $0.text = "Yaw: 0.0"
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    
    private var headphoneLabel = UILabel().then {
        $0.text = "HeadPhone 🔴"
        $0.font = UIFont.systemFont(ofSize: 10)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
        configureAddViews()
        configureLayout()
        HPMotionService.shared.delegate = self
        
//        let scene = GameScene(size: self.view.bounds.size)
//        scene.backgroundColor = .white
//        
//        let skView = SKView()
//        skView.showsFPS = true
//        skView.showsNodeCount = true
//        skView.ignoresSiblingOrder = true
//        skView.presentScene(scene)
//        
//        view.addSubview(skView)
//        skView.snp.makeConstraints { make in
//            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AudioService.shared.playStreamingFromServer()
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask  {
        return UIDevice.current.userInterfaceIdiom == .phone ? .allButUpsideDown : .all
    }
    
    // MARK: - Configure
    private func configureCommonUI() {
        view.backgroundColor = .white
    }
    
    private func configureAddViews() {
        view.addSubview(rollLabel)
        view.addSubview(pitchLabel)
        view.addSubview(yawLabel)
        view.addSubview(headphoneLabel)
    }
    
    private func configureLayout() {
        rollLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(headphoneLabel)
        }
        
        pitchLabel.snp.makeConstraints { make in
            make.top.equalTo(rollLabel.snp.bottom).offset(8)
            make.leading.equalTo(headphoneLabel)
        }
        
        yawLabel.snp.makeConstraints { make in
            make.top.equalTo(pitchLabel.snp.bottom).offset(8)
            make.leading.equalTo(headphoneLabel)
        }
        
        headphoneLabel.snp.makeConstraints { make in
            make.top.equalTo(yawLabel.snp.bottom).offset(8)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-16)
        }
    }
}

extension ViewController: HPMotionDelegate {
    func isHeadPhoneAvailable(_ available: Bool) {
        headphoneLabel.text = "HeadPhone 🔴"
    }
    
    func didHeadPhoneConnected() {
        updateHeadPhoneLabel(true)
    }
    
    func didHeadPhoneDisconnected() {
        updateHeadPhoneLabel(false)
    }
    
    func didHeadPhoneMotionUpdated(_ headRotation: HeadRotation) {
        // TODO: - 머리 각도 전송
        updateHeadRotaionLabel(headRotation)
        AudioService.shared.sendHeadPosition(headRotation)
    }
    
    private func updateHeadPhoneLabel(_ connected: Bool) {
        headphoneLabel.text = connected ? "HeadPhone 🟢" : "HeadPhone 🔴"
    }
    
    private func updateHeadRotaionLabel(_ headRotation: HeadRotation) {
        rollLabel.text = "Roll: \(headRotation.roll)"
        pitchLabel.text = "Pitch: \(headRotation.pitch)"
        yawLabel.text = "Pitch: \(headRotation.yaw)"
    }
}

