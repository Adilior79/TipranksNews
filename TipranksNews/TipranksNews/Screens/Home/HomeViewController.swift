//
//  HomeViewController.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var showNewsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showNewsButton.roundAndShadowed()
    }
}
