//
//  ContentView.swift
//  HomeWork5
//
//  Created by Vitaliy Voronok on 17.04.2020.
//  Copyright © 2020 Vitaliy Voronok. All rights reserved.
//

import Foundation
import RealmSwift

final public class ArticleModel: Object {
    @objc dynamic public var sourceId: String?
    @objc dynamic public var name: String?
    @objc dynamic public var author: String?
    @objc dynamic public var title: String?
    @objc dynamic public var articleDescription: String?
    @objc dynamic public var url: String?
    @objc dynamic public var urlToImage: String?
    @objc dynamic public var publishedAt: String?
    @objc dynamic public var content: String?
    @objc dynamic public var page: Int = 0
    
    init(sourceId: String? = nil, name: String? = nil, author: String? = nil, title: String? = nil, articleDescription: String? = nil, url: String? = nil, urlToImage: String? = nil, publishedAt: String? = nil, content: String? = nil, page: Int = 0) {
        self.sourceId = sourceId
        self.name = name
        self.author = author
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
        self.publishedAt = publishedAt
        self.content = content
        self.page = page
    }
    
    required init() {
        super.init()
    }
}

extension ArticleModel: Identifiable {
    public var id: String {
        self.title ?? UUID().uuidString
    }
}
