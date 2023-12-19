//
//  SelectMusicCollectionViewCell.swift
//  MiPS
//
//  Created by 남유성 on 12/16/23.
//

import UIKit
import SnapKit
import Then

class SelectMusicCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SelectMusicCollectionViewCell"
    
    private var titleLabel = UILabel().then {
        $0.text = "Tell Me If You Wanna Go Home"
        $0.font = Font.light?.withSize(20)
        $0.setKern(-3)
        $0.textColor = .white
    }
    
    private var singerLabel = UILabel().then {
        $0.text = "Keira Knightley"
        $0.font = Font.regular?.withSize(14)
        $0.setKern(-3)
        $0.textColor = UIColor(hexCode: "818181", alpha: 1)
    }
    
    private var instrumentStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    
    // MARK - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCommonUI()
        configureAddViews()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        instrumentStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    // MARK: - Configure
    private func configureCommonUI() {
        
    }
    
    private func configureAddViews() {
        self.addSubview(titleLabel)
        self.addSubview(singerLabel)
        self.addSubview(instrumentStackView)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview()
        }
        
        singerLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        
        instrumentStackView.snp.makeConstraints { make in
            make.top.equalTo(singerLabel.snp.bottom).offset(8)
            make.leading.equalTo(titleLabel)
            make.height.equalTo(28)
        }
    }
    
    func setData(music: Music) {
        titleLabel.text = music.title
        singerLabel.text = music.singer
        
        for instrument in music.instruments {
            let view = InstrumentView(type: instrument, size: .small)
            instrumentStackView.addArrangedSubview(view)
        }
    }
    
    /// tmp
    func disable() {
        titleLabel.textColor = UIColor(hexCode: "555555")
        singerLabel.textColor = UIColor(hexCode: "3E3E3E")
        instrumentStackView.isHidden = true
        
        singerLabel.snp.updateConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
        }

    }
    
    /// tmp
    func updateUI(index: Int) {
        titleLabel.snp.updateConstraints { make in
            if index == 0 {
                make.top.equalToSuperview().offset(28)
            } else if index == 1 {
                make.top.equalToSuperview().offset(18)
            } else if index == 3 {
                make.top.equalToSuperview().offset(24)
            } else if index == 4 {
                make.top.equalToSuperview().offset(12)
            }
            make.leading.equalToSuperview().offset(abs(abs(index - 2) - 2) * 36)
        }
    }
}
