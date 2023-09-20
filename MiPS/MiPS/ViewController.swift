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
        soundSourcePositioning()
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
        
        AudioService.shared.playLocalSource(
            for: DefaultSource.soundHelix.name,
            format: DefaultSource.soundHelix.format
        )
        
        //        AudioService.shared.playExtSource(
        //            from: DefaultSource.soundHelix.url
        //        )
    }
}

