//
//  Article.swift
//  TipranksNews
//
//  Created by Adi Lior on 27/09/2021.
//

import Foundation

struct Article: Decodable {
    let id: Int?
    let title: String?
    let date: String?
    let description: String?
    let thumbnail: Thumbnail?
    let author: Author?
    let image: Image?
    let link: String?
}

struct Thumbnail: Codable {
    let src: String?
}

struct Author: Codable {
    let name: String?
}

struct Image: Codable {
    let src: String?
    let width: Int?
    let height: Int?
}
