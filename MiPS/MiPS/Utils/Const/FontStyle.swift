//
//  FontStyle.swift
//  MiPS
//
//  Created by 남유성 on 12/14/23.
//

import UIKit

public enum Montserrat: String {
    case black = "Montserrat-Black"
    case bold = "Montserrat-Bold"
    case extraBold = "Montserrat-ExtraBold"
    case extraLight = "Montserrat-ExtraLight"
    case light = "Montserrat-Light"
    case medium = "Montserrat-Medium"
    case regular = "Montserrat-Regular"
    case semiBold = "Montserrat-SemiBold"
    case thin = "Montserrat-Thin"
}

enum Font {
    static let black = UIFont(name: Montserrat.black.rawValue, size: 20)
    static let bold = UIFont(name: Montserrat.bold.rawValue, size: 20)
    static let extraBold = UIFont(name: Montserrat.extraBold.rawValue, size: 20)
    static let extraLight = UIFont(name: Montserrat.extraLight.rawValue, size: 20)
    static let light = UIFont(name: Montserrat.light.rawValue, size: 20)
    static let medium = UIFont(name: Montserrat.medium.rawValue, size: 20)
    static let regular = UIFont(name: Montserrat.regular.rawValue, size: 20)
    static let semiBold = UIFont(name: Montserrat.semiBold.rawValue, size: 20)
    static let thin = UIFont(name: Montserrat.thin.rawValue, size: 20)
}
