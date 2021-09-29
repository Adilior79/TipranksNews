//
//  NewsPostsRepository.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation

class NewsPostsRepository {
    private var pageIndex = 1
    private let perPage = 20
    
    func searchPosts(byKey: String? = nil, isPaging: Bool = false, compeletion: @escaping (_ articles: [Article], _ error: Error?) -> Void ) {
        if isPaging {
            pageIndex += 1
        } else {
            pageIndex = 1
        }
        
        var address = "https://www.tipranks.com/api/news/posts"
        address.append("?page=\(pageIndex)")
        address.append("&per_page=\(perPage)")
        if let byKey = byKey {
            address.append("&search=\(byKey)")
        }
        
        NetworkHandler.shared.getRequest(address: address, decodeType: ArticlesList.self) { (isSuccess, response, error) in
            if let error = error {
                compeletion([], error)
            } else {
                if isSuccess {
                    compeletion((response as? ArticlesList)?.data ?? [], nil)
                } else {
                    compeletion([], NetworkError.responseError)
                }
            }
            
        }
    }
}
