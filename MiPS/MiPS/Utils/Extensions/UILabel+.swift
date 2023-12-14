//
//  UILabel.swift
//  MiPS
//
//  Created by 남유성 on 12/14/23.
//

import UIKit
import SnapKit

// MARK - 행간, 자간 조절
extension UILabel {
    
    /// Line Height(행간) 조절
    /// - Parameter lineHeight: 행간 pt
    ///
    /// Line Height pt값을 입력하면 중앙 정렬된 상태로 텍스트의 행간을 조절할 수 있습니다.
    func setLineHeight(_ lineHeight: CGFloat) {
        guard let text = self.text else { return }
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = lineHeight
        style.minimumLineHeight = lineHeight
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .baselineOffset: (lineHeight - font.lineHeight) / 4
        ]
        
        let attributeString = NSAttributedString(string: text, attributes: attributes)
        self.attributedText = attributeString
    }
    
    /// Letter Spacing(자간) 조절
    /// - Parameter letterSpacing: ex) -0.03 퍼센트 값 입력
    ///
    /// Letter spacing(ios에서는 kern) 퍼센트 값을 입력하면 텍스트의 자간을 조절할 수 있습니다.
    func setKern(_ letterSpacing: CGFloat) {
        guard let text = self.text else { return }
        
        let string = NSMutableAttributedString(string: text)
        let kernValue = self.font.pointSize * letterSpacing / 100
        
        string.addAttribute(NSAttributedString.Key.kern, value: kernValue, range: NSRange(location: 0, length: string.length - 1))
        attributedText = string
    }
}
