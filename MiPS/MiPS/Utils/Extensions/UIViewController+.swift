//
//  UIViewController+.swift
//  MiPS
//
//  Created by 남유성 on 12/16/23.
//

import UIKit

extension UIViewController {
    func showToast(message : String) {
        let toastLabel = UILabel().then {
            $0.frame = CGRect(x: 20, y: self.view.frame.size.height - 200, width: self.view.frame.size.width - 40, height: 50)
            $0.backgroundColor = UIColor.white.withAlphaComponent(0.6)
            $0.textColor = UIColor.black
            $0.font = Font.medium?.withSize(14)
            $0.textAlignment = .center
            $0.text = message
            $0.alpha = 1.0
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
        
        self.view.addSubview(toastLabel)
                
        UIView.animate(withDuration: 1.5, delay: 0, options: .curveEaseInOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
