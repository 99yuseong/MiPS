//
//  SelectMusicViewController.swift
//  MiPS
//
//  Created by 남유성 on 12/16/23.
//

import UIKit
import SnapKit
import Then

final class SelectMusicViewController: UIViewController {
    
    let data = [
        Music(
            title: "Lost Stars",
            singer: "Adam Levine",
            instruments: Instruments.allCases
        ),
        Music(
            title: "No One Else Like You",
            singer: "Adam Levine",
            instruments: Instruments.allCases
        ),
        Music(
            title: "Tell Me If You Wanna Go Home",
            singer: "Keira Knightley",
            instruments: Instruments.allCases
        ),
        Music(
            title: "A Higher Place",
            singer: "Adam Levine",
            instruments: Instruments.allCases
        ),
        Music(
            title: "Like A Fool",
            singer: "Keira Knightley",
            instruments: Instruments.allCases
        ),
    ]
    
    // MARK: - UI
    private var circle = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 12
    }
    
    private var border = UIView().then {
        $0.layer.borderWidth = 0.5
        $0.layer.borderColor = UIColor.white.cgColor
        $0.layer.cornerRadius = 60
    }
    
    private var layout = UICollectionViewFlowLayout()
    
    
    private lazy var musicCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: layout
    ).then {
        $0.backgroundColor = UIColor(hexCode: "1c1c1c")
        $0.register(
            SelectMusicCollectionViewCell.self,
            forCellWithReuseIdentifier: SelectMusicCollectionViewCell.identifier
        )
        $0.dataSource = self
        $0.delegate = self
        $0.isPagingEnabled = true
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
    }
    
    private func configureAddViews() {
        view.addSubview(musicCollectionView)
        view.addSubview(circle)
        view.addSubview(border)
    }
    
    private func configureLayout() {
        circle.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerX.equalTo(view.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        border.snp.makeConstraints { make in
            make.width.height.equalTo(120)
            make.centerX.equalTo(view.snp.leading)
            make.centerY.equalToSuperview()
        }
        
        musicCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(32)
            make.height.equalTo((73 + 8) * 5)
            make.trailing.centerY.equalToSuperview()
        }
    }
}

extension SelectMusicViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectMusicCollectionViewCell.identifier,
            for: indexPath) as! SelectMusicCollectionViewCell
        
        cell.setData(music: data[indexPath.row % 5])
        
        cell.updateUI(index: indexPath.row)
        if indexPath.row % 5 != 2 {
            cell.disable()
        }
        
        return cell
    }
}

extension SelectMusicViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCellIndex = indexPath.row
        
        if selectedCellIndex == 2 {
            let vc = PositioningViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showToast(message: "Music is Not Ready")
        }
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        guard let collectionView = scrollView as? UICollectionView else { return }
//        
//        let visibleCells = collectionView.visibleCells
//        
//        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
//        
//        let selectedMinPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY - 28)
//        let selectedMaxPoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY + 28)
//            
//        if let indexPath = collectionView.indexPathForItem(at: selectedMinPoint) {
//            let cell = collectionView.cellForItem(at: indexPath)
//                
//            cell?.transform = CGAffineTransform(translationX: 56, y: 0)
//
//        } else if let indexPath = collectionView.indexPathForItem(at: selectedMinPoint) {
//            let cell = collectionView.cellForItem(at: indexPath)
//
//            cell?.transform = CGAffineTransform(translationX: 56, y: 0)
//        }
//    }
}

extension SelectMusicViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 73)
    }
}

#if DEBUG

import SwiftUI

struct SelectMusicViewController_ViewPresentable: UIViewControllerRepresentable {
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        SelectMusicViewController()
    }
    
    
}

struct SelectMusicViewController_PreviewProvider : PreviewProvider {
    static var previews: some View {
        SelectMusicViewController_ViewPresentable()
            .ignoresSafeArea()
    }
}

#endif
