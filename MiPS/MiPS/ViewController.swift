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
    
    var audio: Audio!
    var player: MiPSPlayer!
    
    // MARK: - UI
    private var titleLabel = UILabel().then {
        $0.text = "Hello world"
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
        
        audio = Audio(
            name: "soundhelix_mono",
            ext: .mp3,
            type: .guitar,
            frameCount: 512
        )
        
        player = MiPSPlayer(audio: audio)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkService.shared.connect()
        NetworkService.shared.playerNode.play()
    }
    
    // MARK: - Configure
    private func configureCommonUI() {
        view.backgroundColor = .white
    }
    
    private func configureAddViews() {
        view.addSubview(titleLabel)
        view.addSubview(playBtn)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
        
        playBtn.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}

extension ViewController {
    @objc func playMusic() {
//        NetworkService.shared.sendMessage("1")
//        NetworkService.shared.playerNode.play()
//        player.play()
//        AudioService.shared.playLocalSource(
//            for: DefaultSource.soundHelix.name,
//            format: DefaultSource.soundHelix.format as! AudioExt
//        )
    }
}

