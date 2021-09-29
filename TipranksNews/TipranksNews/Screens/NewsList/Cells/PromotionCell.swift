//
//  PromotionCell.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import UIKit

protocol PromotionCellProtocol: class {
    func promotionTapped(_ promotionCell: PromotionCell)
}

class PromotionCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gotoPromotionButton: UIButton!
    
    static let identifier = "PromotionCell"
    weak var delegate: PromotionCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI() {
        containerView.roundAndShadowed()
        gotoPromotionButton.roundAndShadowed()
    }
    
    @IBAction func goToPromotion(_ sender: UIButton) {
        delegate?.promotionTapped(self)
    }
}
