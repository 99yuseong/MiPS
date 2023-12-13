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
    
    private let audioService = AudioService()
    private var lastSentHeadRot = HeadRotation(roll: 0, pitch: 0, yaw: 0)
    
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
    
    private lazy var playBtn = UIButton().then {
        $0.setTitle("play", for: .normal)
        $0.layer.backgroundColor = UIColor.black.cgColor
        $0.addTarget(self, action: #selector(playBtnTap), for: .touchUpInside)
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
        configureAddViews()
        configureLayout()
        HPMotionService.shared.delegate = self
        audioService.delegate = self
        
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
        audioService.connectServer()
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
        view.addSubview(playBtn)
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
        
        playBtn.snp.makeConstraints { make in
            make.width.height.equalTo(50)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-300)
        }
    }
}

extension ViewController {
    @objc func playBtnTap() {
        if playBtn.titleLabel?.text == "play" {
            playBtn.setTitle("pause", for: .normal)
            audioService.play()
        } else {
            playBtn.setTitle("play", for: .normal)
            audioService.pause()
        }
    }
}

extension ViewController: AudioServiceDelegate {
    func willAudioPlayOnServer() {
        NetworkService.shared.setSocketEvent { [weak self] event in
            guard let self = self else { return }
            
            switch event {
            case .text(let jsonString):
                self.audioService.loadBufferSemaphore(jsonString)
            default:
                break
            }
        }
        
        NetworkService.shared.connectSocket()
    }
    
    func willAudioEndOnServer() {
        //
    }
    
    func didAudioPlayOnServer() {
        //
    }
    
    func didAudioEndOnServer() {
        NetworkService.shared.disconnectSocket()
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
//        if lastSentHeadRot.differOver(degree: 5, headRot: headRotation) {
//            audioService.sendPlayingData(headRotation)
//            lastSentHeadRot = headRotation
//        }
        audioService.sendPlayingData(headRotation)
        updateHeadRotaionLabel(headRotation)
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

#if DEBUG

import SwiftUI

struct ViewController_ViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        ViewController()
    }
    
    
}

struct ViewController_PreviewProvider : PreviewProvider {
    static var previews: some View {
        ViewController_ViewPresentable()
            .ignoresSafeArea()
    }
}

#endif
