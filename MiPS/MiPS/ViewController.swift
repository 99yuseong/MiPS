//
//  ViewController.swift
//  MiPS
//
//  Created by 남유성 on 2023/09/19.
//

import UIKit
import SnapKit
import Then

final class ViewController: UIViewController {
    
    // MARK: - UI
    private var titleLabel = UILabel().then {
        $0.text = "Hello world"
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
        view.backgroundColor = .white
    }
    
    private func configureAddViews() {
        view.addSubview(titleLabel)
    }
    
    private func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

