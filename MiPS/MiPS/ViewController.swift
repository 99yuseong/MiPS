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

final class ViewController: UIViewController {
    
    // MARK: - UI
    private var rollLabel = UILabel().then {
        $0.text = "Roll: 0.0"
    }
    
    private lazy var rollSlider = UISlider().then {
        $0.minimumValue = -180
        $0.maximumValue = 180
        $0.isContinuous = true
        $0.tintColor = UIColor.red
        $0.addTarget(
            self,
            action: #selector(rollValueChanged(_:)),
            for: .valueChanged)
    }
    
    private var pitchLabel = UILabel().then {
        $0.text = "Pitch: 0.0"
    }
    
    private lazy var pitchSlider = UISlider().then {
        $0.minimumValue = -180
        $0.maximumValue = 180
        $0.isContinuous = true
        $0.tintColor = UIColor.green
        $0.addTarget(
            self,
            action: #selector(pitchValueChanged(_:)),
            for: .valueChanged)
    }
    
    private var yawLabel = UILabel().then {
        $0.text = "Yaw: 0.0"
    }
    
    private lazy var yawSlider = UISlider().then {
        $0.minimumValue = -180
        $0.maximumValue = 180
        $0.isContinuous = true
        $0.tintColor = UIColor.blue
        $0.addTarget(
            self,
            action: #selector(yawValueChanged(_:)),
            for: .valueChanged)
    }
    
    private lazy var playBtn = UIButton().then {
        $0.setTitle("재생", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
        configureAddViews()
        configureLayout()
    }
    
    // MARK: - Configure
    private func configureCommonUI() {
        view.backgroundColor = .white
    }
    
    private func configureAddViews() {
        view.addSubview(rollLabel)
        view.addSubview(rollSlider)
        view.addSubview(pitchLabel)
        view.addSubview(pitchSlider)
        view.addSubview(yawLabel)
        view.addSubview(yawSlider)
        view.addSubview(playBtn)
    }
    
    private func configureLayout() {
        rollLabel.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalToSuperview().offset(100)
        }
        
        rollSlider.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(20)
            make.top.equalTo(rollLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        pitchLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rollSlider.snp.bottom).offset(40)
        }
        
        pitchSlider.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(20)
            make.top.equalTo(pitchLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        yawLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(pitchSlider.snp.bottom).offset(40)
        }
        
        yawSlider.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(20)
            make.top.equalTo(yawLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        playBtn.snp.makeConstraints { make in
            make.top.equalTo(yawSlider.snp.bottom).offset(100)
            make.centerX.equalToSuperview()
        }
    }
    
    @objc func rollValueChanged(_ sender: UISlider) {
        rollLabel.text = "Roll: \(String(format: "%.1f", sender.value))"
        sendHeadPositionData()
    }
         
    @objc func pitchValueChanged(_ sender: UISlider) {
        pitchLabel.text = "Pitch: \(String(format: "%.1f", sender.value))"
        sendHeadPositionData()
    }
         
    @objc func yawValueChanged(_ sender: UISlider) {
        yawLabel.text = "Yaw: \(String(format: "%.1f", sender.value))"
        sendHeadPositionData()
    }
    
    func sendHeadPositionData() {
        let position = HeadPosition(
            roll: rollSlider.value.roundToFirst(),
            pitch: pitchSlider.value.roundToFirst(),
            yaw: yawSlider.value.roundToFirst()
        )
        AudioService.shared.sendHeadPosition(position)
    }
}

extension ViewController {
    @objc func playMusic() {
        AudioService.shared.playStreamingFromServer()
    }
}

