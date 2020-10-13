//
//  Utillties.swift
//  JYCardView
//
//  Created by 王笑宇 on 2020/10/13.
//

import UIKit

extension UIColor {
    static var random: UIColor {
        get {
            UIColor(red: CGFloat.random(in: 0...1.0), green: CGFloat.random(in: 0...1.0), blue: CGFloat.random(in: 0...1.0), alpha: 1)
        }
    }
}

