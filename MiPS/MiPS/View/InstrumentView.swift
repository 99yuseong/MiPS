//
//  InstrumentView.swift
//  MiPS
//
//  Created by 남유성 on 12/16/23.
//

import UIKit
import SnapKit
import Then

enum InstrumentViewSize {
    case large
    case small
}

class InstrumentView: UIView {
    
    let type: Instruments
    let size: InstrumentViewSize
    private var width: CGFloat {
        switch size {
        case .large:
            36
        case .small:
            28
        }
    }
    
    private var instrumentLabel = UILabel().then {
        $0.textColor = .white
        $0.font = Font.semiBold?.withSize(14)
        $0.setKern(-3)
    }
    
    init(type: Instruments, size: InstrumentViewSize) {
        self.type = type
        self.size = size
        super.init(frame: .zero)
        
        configureCommonUI()
        configureAddViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    private func configureCommonUI() {
        instrumentLabel.text = self.type.rawValue
        instrumentLabel.font = size == .large ? Font.semiBold?.withSize(18) : Font.semiBold?.withSize(14)
        self.layer.cornerRadius = size == .large ? 18 : 14
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.5
    }
    
    private func configureAddViews() {
        self.addSubview(instrumentLabel)
    }
    
    private func configureLayout() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(width)
        }
        
        instrumentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

