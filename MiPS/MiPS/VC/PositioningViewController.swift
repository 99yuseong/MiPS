//
//  PositioningViewController.swift
//  MiPS
//
//  Created by 남유성 on 12/18/23.
//

import UIKit
import SnapKit
import Then
import SpriteKit

final class PositioningViewController: UIViewController {
    
    private let audioService = AudioService()
    private var lastSentHeadRot = HeadRotation(roll: 0, pitch: 0, yaw: 0)
    
    // MARK: - UI
    private var rollLabel = UILabel().then {
        $0.text = "Roll: 0.0"
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .white
    }
    
    private var pitchLabel = UILabel().then {
        $0.text = "Pitch: 0.0"
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .white
    }
        
    private var yawLabel = UILabel().then {
        $0.text = "Yaw: 0.0"
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .white
    }
    
    private var headphoneLabel = UILabel().then {
        $0.text = "HeadPhone 🔴"
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .white
    }
    
    private lazy var menuBtn = IconBtn(of: Icon.menu, color: .white).then {
        $0.addTarget(self, action: #selector(selectMusic), for: .touchUpInside)
    }
    
    private lazy var resetBtn = IconBtn(of: Icon.reset, color: .white).then {
        $0.isHidden = true
        $0.addTarget(self, action: #selector(resetScene), for: .touchUpInside)
    }
    
    private var titleLabel = UILabel().then {
        $0.text = "Tell Me If You Wanna Go Home"
        $0.textColor = .white
        $0.font = Font.light?.withSize(18)
        $0.setKern(-3)
    }
    
    private var singerLabel = UILabel().then {
        $0.text = "Keira Knightley"
        $0.textColor = UIColor(hexCode: "818181")
        $0.font = Font.light?.withSize(14)
        $0.setKern(-3)
    }
    
    private lazy var playBtn = IconBtn(of: Icon.play, color: .white).then {
        $0.addTarget(self, action: #selector(playMusic), for: .touchUpInside)
    }
    
    private lazy var pauseBtn = IconBtn(of: Icon.pause, color: .white).then {
        $0.isHidden = true
        $0.addTarget(self, action: #selector(pauseMusic), for: .touchUpInside)
    }
    
    private var headerDivider = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 0.1
    }
    
    private lazy var scene = PositioningScene(size: self.view.bounds.size).then {
        $0.backgroundColor = UIColor(hexCode: "1c1c1c")
        $0.scaleMode = .resizeFill
        $0.yScale = -1
        $0.positioningDelegate = self
    }
    
    private lazy var skView = SKView().then {
        $0.ignoresSiblingOrder = true
        $0.layer.borderWidth = 0
        $0.presentScene(scene)
    }
    
    private var infoLabel = UILabel().then {
        $0.text = "Drag and Position Instruments"
        $0.textColor = .white
        $0.font = Font.regular?.withSize(16)
        $0.setKern(-3)
    }
    
    private var bottomDivider = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 0.1
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
        configureAddViews()
        configureLayout()
        HPMotionService.shared.delegate = self
        audioService.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scene.size = self.view.bounds.size
        scene.setUp()
        scene.addInstrumentNodes(Instruments.allCases)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        audioService.connectServer()
    }
    
    // MARK: - Configure
    private func configureCommonUI() {
        view.backgroundColor = UIColor(hexCode: "1c1c1c")
    }
    
    @objc func didTouchDown(sender: UILongPressGestureRecognizer) {
        let location = view.convert(sender.view!.frame, from: sender.view!.superview)
        let type = (sender.view as! InstrumentView).type
        let skSceneCenter = CGPoint(x: location.midX, y: view.bounds.height - location.midY)
        
        addNode(for: type, at: skSceneCenter)
    }
    
    private func configureAddViews() {
        view.addSubview(skView)
        view.addSubview(menuBtn)
        view.addSubview(resetBtn)
        view.addSubview(titleLabel)
        view.addSubview(singerLabel)
        view.addSubview(playBtn)
        view.addSubview(pauseBtn)
        view.addSubview(headerDivider)
        view.addSubview(infoLabel)
        view.addSubview(bottomDivider)
        
        view.addSubview(rollLabel)
        view.addSubview(pitchLabel)
        view.addSubview(yawLabel)
        view.addSubview(headphoneLabel)
        view.addSubview(playBtn)
    }
    
    private func configureLayout() {
        menuBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(10)
        }
        
        resetBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(62)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(14.5)
        }
        
        singerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        playBtn.snp.makeConstraints { make in
            make.top.equalTo(menuBtn)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        pauseBtn.snp.makeConstraints { make in
            make.top.equalTo(menuBtn)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        headerDivider.snp.makeConstraints { make in
            make.height.equalTo(0.2)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(menuBtn.snp.bottom).offset(8)
        }
        
        skView.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalToSuperview()
        }
        
        rollLabel.snp.makeConstraints { make in
            make.top.equalTo(headerDivider.snp.bottom).offset(16)
            make.leading.equalTo(headphoneLabel)
        }
        
        pitchLabel.snp.makeConstraints { make in
            make.top.equalTo(rollLabel.snp.bottom).offset(2)
            make.leading.equalTo(headphoneLabel)
        }
        
        yawLabel.snp.makeConstraints { make in
            make.top.equalTo(pitchLabel.snp.bottom).offset(2)
            make.leading.equalTo(headphoneLabel)
        }
        
        headphoneLabel.snp.makeConstraints { make in
            make.top.equalTo(yawLabel.snp.bottom).offset(2)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
}

extension PositioningViewController {
    func addNode(for type: Instruments, at location: CGPoint) {
        let node = InstrumentNode(type: type)
        node.position = location
        scene.addChild(node)
        scene.selectedNode = node
    }
}

extension PositioningViewController {
    @objc func selectMusic() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func playMusic() {
        guard scene.isMusicAvailable() else {
            showToast(message: "Drag and Position Instruments")
            return
        }
//        audioService.play()
        pauseBtn.isHidden = false
        playBtn.isHidden = true
        scene.playMusic()
    }
    
    @objc func pauseMusic() {
//        audioService.pause()
        playBtn.isHidden = false
        pauseBtn.isHidden = true
        scene.pauseMusic()
    }
    
    @objc func resetScene() {
        scene.resetAll()
        resetPositioning()
        pauseBtn.isHidden = true
        playBtn.isHidden = false
        showToast(message: "음악 리셋해야함!!!")
    }
}

extension PositioningViewController: PositioningSceneDelegate {
    func startPositioning() {
        resetBtn.isHidden = false
        menuBtn.isHidden = true
    }
    
    func resetPositioning() {
        resetBtn.isHidden = true
        menuBtn.isHidden = false
    }
}

extension PositioningViewController: AudioServiceDelegate {
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

extension PositioningViewController: HPMotionDelegate {
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

struct PositioningViewController_ViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        PositioningViewController()
    }
    
    
}

struct PositioningViewController_PreviewProvider : PreviewProvider {
    static var previews: some View {
        PositioningViewController_ViewPresentable()
            .ignoresSafeArea()
    }
}

#endif
