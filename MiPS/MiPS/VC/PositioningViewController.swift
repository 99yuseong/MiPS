//
//  PositioningViewController.swift
//  MiPS
//
//  Created by 남유성 on 12/18/23.
//

import UIKit
import SnapKit
import Then

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
        $0.textColor = UIColor(hexCode: "818181", alpha: 1)
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
    
    private var scrollView = UIScrollView()
    
    private lazy var stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .equalSpacing
        $0.alignment = .center
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
        view.backgroundColor = UIColor(hexCode: "1c1c1c")
        configureStackView()
    }
    
    private func configureStackView() {
        for type in Instruments.allCases {
            let view = InstrumentsView(type: type, size: .large)
            stackView.addArrangedSubview(view)
        }
    }
    
    private func configureAddViews() {
        view.addSubview(menuBtn)
        view.addSubview(titleLabel)
        view.addSubview(singerLabel)
        view.addSubview(playBtn)
        view.addSubview(headerDivider)
        view.addSubview(infoLabel)
        view.addSubview(bottomDivider)
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
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
        
        infoLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.height.equalTo(0.2)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.bottom.equalTo(scrollView.snp.top)
        }
        
        scrollView.snp.makeConstraints { make in
            make.height.equalTo(72)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.leading.equalTo(scrollView).offset(32)
        }
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
