//
//  ArticlesListViewModel.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation

class ArticlesListViewModel {
    let articleViewModelsList: Observable<[ArticleViewModel]> = Observable([])
    let articlesListError: Observable<Error?> = Observable(nil)
    
    private let newsPostsRepository = NewsPostsRepository()
    
    func searchPosts(byKey: String? = nil, isPaging: Bool = false) {
        newsPostsRepository.searchPosts(byKey: byKey, isPaging: isPaging) { [weak self] (articles, error) in
            if let error = error {
                self?.articlesListError.value = error
            } else {
                var articleViewModelsArr: [ArticleViewModel] = []
                
                for article in articles {
                    let articleViewModel = ArticleViewModel(article: article)
                    articleViewModelsArr.append(articleViewModel)
                }
                
                if isPaging {
                    self?.articleViewModelsList.value.append(contentsOf: articleViewModelsArr)
                } else {
                    self?.articleViewModelsList.value = articleViewModelsArr
                }
            }
        }
    }
}
