//
//  InitViewController.swift
//  MiPS
//
//  Created by 남유성 on 12/13/23.
//

import UIKit
import SnapKit
import Then

final class InitViewController: UIViewController {
    
    enum HPStatus: String {
        case notSupported = "Device Not Supported"
        case notConnected = "Please Connect HeadPhone"
        case connected = "Start Music Spatialization"
    }
    
    private var headPhoneStatus: HPStatus = .notSupported
    
    // MARK: - UI
    private var mLabel = UILabel().then {
        $0.text = "M"
    }
    
    private var firstLabel = UILabel().then {
        $0.text = "usic"
    }
    
    private var iLabel = UILabel().then {
        $0.text = "I"
    }
    
    private var secondLabel = UILabel().then {
        $0.text = "nstrument"
    }
    
    private var pLabel = UILabel().then {
        $0.text = "P"
    }
    
    private var thirdLabel = UILabel().then {
        $0.text = "ositioning"
    }
    
    private var sLabel = UILabel().then {
        $0.text = "S"
    }
    
    private var fourthLabel = UILabel().then {
        $0.text = "patialization"
    }
    
    private var labelContainer = UIView()
    
    private lazy var buttonView = UIView().then {
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 8
        $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didButtonTap)))
    }
    
    private var buttonText = UILabel().then {
        $0.text = "Please Connect HeadPhone"
        $0.font = Font.regular?.withSize(13)
        $0.textColor = .white
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCommonUI()
        configureAddViews()
        configureLayout()
        HPMotionService.shared.delegate = self
        HPMotionService.shared.startUpdate()
    }
    
    // MARK: - Configure
    private func configureCommonUI() {
        view.backgroundColor = UIColor(hexCode: "1c1c1c")
        configureBoldLabel(label: mLabel)
        configureBoldLabel(label: iLabel)
        configureBoldLabel(label: pLabel)
        configureBoldLabel(label: sLabel)
        configureLightLabel(label: firstLabel)
        configureLightLabel(label: secondLabel)
        configureLightLabel(label: thirdLabel)
        configureLightLabel(label: fourthLabel)
    }
    
    private func configureBoldLabel(label: UILabel) {
        label.font = Font.semiBold?.withSize(24)
        label.textColor = .white
        label.setKern(1.6)
    }
    
    private func configureLightLabel(label: UILabel) {
        label.font = Font.light?.withSize(18)
        label.textColor = .white
        label.setKern(-3)
    }
    
    private func configureAddViews() {
        view.addSubview(labelContainer)
        view.addSubview(buttonView)
        labelContainer.addSubview(mLabel)
        labelContainer.addSubview(iLabel)
        labelContainer.addSubview(pLabel)
        labelContainer.addSubview(sLabel)
        labelContainer.addSubview(firstLabel)
        labelContainer.addSubview(secondLabel)
        labelContainer.addSubview(thirdLabel)
        labelContainer.addSubview(fourthLabel)
        buttonView.addSubview(buttonText)
    }
    
    private func configureLayout() {
        labelContainer.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.width.equalTo(120)
        }
        
        mLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        iLabel.snp.makeConstraints { make in
            make.top.equalTo(mLabel.snp.bottom)
            make.leading.equalTo(mLabel)
        }
        
        pLabel.snp.makeConstraints { make in
            make.top.equalTo(iLabel.snp.bottom)
            make.leading.equalTo(mLabel)
        }
        
        sLabel.snp.makeConstraints { make in
            make.top.equalTo(pLabel.snp.bottom)
            make.leading.equalTo(mLabel)
        }
        
        firstLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mLabel)
            make.leading.equalTo(mLabel.snp.trailing)
        }
        
        secondLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iLabel)
            make.leading.equalTo(iLabel.snp.trailing)
        }
        
        thirdLabel.snp.makeConstraints { make in
            make.centerY.equalTo(pLabel)
            make.leading.equalTo(pLabel.snp.trailing)
        }
        
        fourthLabel.snp.makeConstraints { make in
            make.centerY.equalTo(sLabel)
            make.leading.equalTo(sLabel.snp.trailing)
        }
        
        buttonView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.trailing.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
        
        buttonText.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension InitViewController: HPMotionDelegate {
    func isHeadPhoneAvailable(_ available: Bool) {
        headPhoneStatus = available ? .notConnected : .notSupported
        buttonText.text = headPhoneStatus.rawValue
    }
    
    func didHeadPhoneConnected() {
        headPhoneStatus = .connected
        buttonText.text = headPhoneStatus.rawValue
    }
    
    func didHeadPhoneDisconnected() {
        headPhoneStatus = .notConnected
        buttonText.text = headPhoneStatus.rawValue
    }
    
    func didHeadPhoneMotionUpdated(_ headRotation: HeadRotation) {
        print("updated")
    }
}

extension InitViewController {
    @objc func didButtonTap() {
        showToast(message: headPhoneStatus.rawValue)
    }
}

#if DEBUG

import SwiftUI

struct InitViewController_ViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        InitViewController()
    }
    
    
}

struct InitViewController_PreviewProvider : PreviewProvider {
    static var previews: some View {
        InitViewController_ViewPresentable()
            .ignoresSafeArea()
    }
}

#endif
