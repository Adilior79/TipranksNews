//
//  UIView+RoundedCorners.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation
import UIKit

extension UIView
{
    func roundCorners(corners: CACornerMask, radius: CGFloat)
    {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        self.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
    }
}
