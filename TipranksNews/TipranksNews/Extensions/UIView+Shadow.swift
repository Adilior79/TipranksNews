//
//  UIView+Shadow.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation

import UIKit

extension UIView
{
    func roundAndShadowed() {
        layer.cornerRadius = 10.0
       
        layer.masksToBounds = false
        layer.shadowRadius = 3
        layer.shadowOpacity = 1
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0 , height: 2)
    }
}

