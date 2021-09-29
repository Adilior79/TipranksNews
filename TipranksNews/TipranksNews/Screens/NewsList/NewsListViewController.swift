//
//  NewsListViewController.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import UIKit

class NewsListViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIView!
    
    private var articlesListViewModel = ArticlesListViewModel()
    private var articlesList: [ArticleViewModel] = []
    
    private var promotionsIndexes: [Int] = []
    private var isPagingEnabled = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
        setupUI()
        bind(to: articlesListViewModel)
    }
    
    private func registerCells() {
        tableView.register(UINib(nibName: ArticleCell.identifier, bundle: nil), forCellReuseIdentifier: ArticleCell.identifier)
        tableView.register(UINib(nibName: PromotionCell.identifier, bundle: nil), forCellReuseIdentifier: PromotionCell.identifier)
    }
    
    private func setupUI() {
        activityIndicatorView.layer.cornerRadius = 8.0
        activityIndicatorView.layer.borderWidth = 1.0
        activityIndicatorView.layer.borderColor = UIColor.lightGray.cgColor
        
        searchButton.roundAndShadowed()
    }
    
    private func bind(to viewModel: ArticlesListViewModel) {
        self.articlesListViewModel = viewModel
        
        articlesListViewModel.articleViewModelsList.observe { [weak self] articlesList in
            self?.articlesList = articlesList
            self?.isPagingEnabled = true
            DispatchQueue.main.async {
                self?.calcPromotionsCount()
                self?.tableView.reloadData {
                    self?.activityIndicatorView.isHidden = true
                }
            }
        }
        
        articlesListViewModel.articlesListError.observe { [weak self] error in
            DispatchQueue.main.async {
                self?.tableView.reloadData {
                    self?.activityIndicatorView.isHidden = true
                }
            }
            
            // error handling
            if let _ = error {
                
            }
        }
    }
    
    @IBAction func searchTapped(_ sender: UIButton) {
        textField.resignFirstResponder()
        searchArticles()
    }
    
    private func searchArticles(isPaging: Bool = false) {
        if isPaging == false {
            // scroll to top of the tableView
            let firstIndexPath = IndexPath(row: 0, section: 0)
            if firstIndexPath.section < tableView.numberOfSections && firstIndexPath.row < tableView.numberOfRows(inSection: firstIndexPath.section) {
                tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
        
        if let searchKey = textField.text, searchKey.count > 0 {
            activityIndicatorView.isHidden = false
            articlesListViewModel.searchPosts(byKey: searchKey, isPaging: isPaging)
        } else {
            activityIndicatorView.isHidden = true
        }
    }
}

// MARK:- UITableViewDelegate, UITableViewDataSource
extension NewsListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesList.count + promotionsIndexes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if promotionsIndexes.contains(indexPath.row) {
            guard let promotionCell = tableView.dequeueReusableCell(withIdentifier: PromotionCell.identifier) as? PromotionCell else {
                return UITableViewCell()
            }
            
            promotionCell.delegate = self
            return promotionCell
            
        } else {
            guard let articleCell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.identifier) as? ArticleCell else {
                return UITableViewCell()
            }
            
            let articleIndex = getArticleIndex(tableIndexRow: indexPath.row)
            articleCell.id = articlesList[articleIndex].id
            articleCell.articleViewModel = articlesList[articleIndex]

            return articleCell
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        // you reached end of the scroller
        if distanceFromBottom < height && isPagingEnabled {
            activityIndicatorView.isHidden = false
            isPagingEnabled = false
            searchArticles(isPaging: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if promotionsIndexes.contains(indexPath.row) {
            return
        }
        
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        if let articleDetailsVC = mainSB.instantiateViewController(identifier: "ArticleDetailsViewController") as? ArticleDetailsViewController {
            articleDetailsVC.articleViewModel = articlesList[getArticleIndex(tableIndexRow: indexPath.row)]
            navigationController?.pushViewController(articleDetailsVC, animated: true)
        }
    }
}

// MARK:- UITextFieldDelegate
extension NewsListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchArticles()
        
        return true
    }
}

// MARK:- Promotions Calculations
extension NewsListViewController {
    private func calcPromotionsCount() {
        promotionsIndexes = []
        var promotionIndex = 3 // beacause the index starts from 0 this will be the forth item on the table view
        
        while promotionIndex < (articlesList.count + promotionsIndexes.count) {
            promotionsIndexes.append(promotionIndex)
            promotionIndex += 11
        }
    }
    
    // get the real article index without the promotion indexes
    private func getArticleIndex(tableIndexRow: Int) -> Int {
        var promotionIndex = 3
        var promotionsCountBelowIndex = 0
        
        while promotionIndex < tableIndexRow {
            promotionsCountBelowIndex += 1
            promotionIndex += 10
        }
        
        return tableIndexRow - promotionsCountBelowIndex
    }
}

// MARK:- PromotionCellProtocol
extension NewsListViewController: PromotionCellProtocol {
    func promotionTapped(_ promotionCell: PromotionCell) {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        if let articleDetailsVC = mainSB.instantiateViewController(identifier: "ArticleDetailsViewController") as? ArticleDetailsViewController {
            let articleViewModel = ArticleViewModel()
            articleViewModel.setPromotionLink()
            articleDetailsVC.articleViewModel = articleViewModel
            
            navigationController?.pushViewController(articleDetailsVC, animated: true)
        }
    }
}
