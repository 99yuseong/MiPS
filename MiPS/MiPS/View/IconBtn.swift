//
//  IconBtn.swift
//  MiPS
//
//  Created by 남유성 on 12/18/23.
//

import UIKit
import SnapKit
import Then

class IconBtn: UIButton {
    
    private var iconImageView = UIImageView()
    private let color: UIColor?
    private let imageSize: Int
    private let btnSize: Int
    
    init(of icon: UIImage?, color: UIColor?, imageSize: Int = 24, btnSize: Int = 44) {
        self.color = color
        self.imageSize = imageSize
        self.btnSize = btnSize
        
        super.init(frame: .zero)
        
        configureIconImageView(to: icon)
        configureAddViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureIconImageView(to icon: UIImage?) {
        iconImageView.image = icon
        iconImageView.tintColor = color
    }
    
    private func configureAddViews() {
        self.addSubview(iconImageView)
    }
    
    private func configureLayout() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(btnSize)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.width.height.equalTo(imageSize)
            make.center.equalTo(self)
        }
    }
    
    func setTintColor(to color: UIColor?) {
        self.iconImageView.tintColor = color
    }
    
    func setIcon(to icon: UIImage?) {
        iconImageView.image = icon
        iconImageView.tintColor = color
    }
}
