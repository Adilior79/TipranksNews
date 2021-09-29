//
//  UITableView+Reload.swift
//  TipranksNews
//
//  Created by Adi Lior on 28/09/2021.
//

import Foundation
import UIKit

extension UITableView {
    func reloadData(completion:@escaping ()->()) {
        UIView.animate(withDuration: 0, animations: reloadData)
            { _ in completion() }
    }
}
