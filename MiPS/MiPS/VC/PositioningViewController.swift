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
    
    // MARK: - UI
    private lazy var menuBtn = IconBtn(of: Icon.menu, color: .white).then {
        $0.addTarget(self, action: #selector(selectMusic), for: .touchUpInside)
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
    
    private var headerDivider = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 0.1
    }
    
    private lazy var scene = PositioningScene(size: self.view.bounds.size).then {
        $0.backgroundColor = .clear
        $0.scaleMode = .resizeFill
        $0.yScale = -1
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        scene.size = self.view.bounds.size
        scene.addUserNode()
        scene.addInstrumentNodes(Instruments.allCases)
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
        view.addSubview(titleLabel)
        view.addSubview(singerLabel)
        view.addSubview(playBtn)
        view.addSubview(headerDivider)
        view.addSubview(infoLabel)
        view.addSubview(bottomDivider)
    }
    
    private func configureLayout() {
        menuBtn.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalToSuperview().offset(10)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(menuBtn.snp.trailing).offset(8)
            make.top.equalTo(menuBtn).offset(2.5)
        }
        
        singerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        playBtn.snp.makeConstraints { make in
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
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.height.equalTo(0.2)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-50)
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
        showToast(message: "Play")
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
