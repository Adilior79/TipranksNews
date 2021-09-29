//
//  ArticleViewModel.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation

class ArticleViewModel {
    var id: Int?
    var title: String?
    var date: String?
    var description: String?
    var thumbnailURL: String?
    var authorName: String?
    var imageURL: String?
    var link: String?
    
    init() {}
    
    init(article: Article) {
        id = article.id
        title = article.title
        description = article.description
        thumbnailURL = article.thumbnail?.src
        authorName = article.author?.name
        imageURL = article.image?.src
        link = article.link
        calcDate(article.date)
    }
        
    func setPromotionLink() {
        link = "https://www.tipranks.com"
    }
    
    private func calcDate(_ articleDateStr: String?) {
        guard let articleDateStr = articleDateStr else {
            date = nil
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
         
        if let articleDate = dateFormatter.date(from: articleDateStr) {
            let interval = Date() - articleDate
            if let minute = interval.minute, let hour = interval.hour, let day = interval.day {
                switch (minute, hour, day) {
                case (let minute, 0, 0) where minute < 5:
                    date = "Now"
                    
                case (let minute, 0, 0) where minute > 5:
                    date = "\(minute) minutes ago"
                    
                case (_, let hour, 0) where hour < 24:
                    date = "\(hour) hours ago"
                    
                case (_, _, let day) where day < 7:
                    date = "\(day) days ago"
                    
                default:
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    date = dateFormatter.string(from: articleDate)
                }
            }
        }
    }
}
