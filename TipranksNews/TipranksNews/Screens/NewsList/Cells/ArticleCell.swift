//
//  ArticleCell.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var articleImageView: UIImageView!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var thumbActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var headlineLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var articleDateLabel: UILabel!
    @IBOutlet weak var newsDescriptionLabel: UILabel!
    
    static let identifier = "ArticleCell"
    var id: Int?

    var articleViewModel: ArticleViewModel! {
        didSet {
            if let articleId = articleViewModel.id {
                configure(articleId: articleId)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        thumbActivityIndicator.isHidden = false
        articleImageView.image = UIImage(named: "ImageLoading")
        thumbImageView.image = nil
    }
    
    private func setupUI() {
        containerView.roundAndShadowed()
        articleImageView.roundCorners(corners: [.layerMinXMinYCorner,.layerMaxXMinYCorner], radius: 10)
        thumbImageView.layer.cornerRadius = thumbImageView.frame.height / 2
    }
    
    private func configure(articleId: Int) {
        headlineLabel.text = articleViewModel.title ?? ""
        authorNameLabel.text = articleViewModel.authorName ?? ""
        newsDescriptionLabel.text = articleViewModel.description ?? ""
        articleDateLabel.text = articleViewModel.date ?? ""
        
        guard let imageURLString = articleViewModel.imageURL,
              let thumbURLString = articleViewModel.thumbnailURL,
              let imageURL = URL(string: imageURLString),
              let thumbURL = URL(string: thumbURLString) else {
            return
        }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            do {
                let imageData = try Data(contentsOf: imageURL)
                DispatchQueue.main.async {
                    if self?.id == articleId {
                        self?.articleImageView.image = UIImage(data: imageData)
                    } 
                }
            } catch {
                print("Unable to load data: \(error)")
            }
            
            do {
                let imageData = try Data(contentsOf: thumbURL)
                DispatchQueue.main.async {
                    if self?.id == articleId {
                        self?.thumbImageView.image = UIImage(data: imageData)
                        self?.thumbActivityIndicator.isHidden = true
                    }
                }
            } catch {
                print("Unable to load data: \(error)")
            }
        }
    }
}
