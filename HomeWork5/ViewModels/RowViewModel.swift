//
//  RowViewModel.swift
//  HomeWork5
//
//  Created by Vitaliy Voronok on 17.04.2020.
//  Copyright © 2020 Vitaliy Voronok. All rights reserved.
//

import Foundation

final class RowViewModel: ObservableObject {
    @Published var contentViewModel: ContentViewModel
    @Published var article: ArticleModel
    
    var isLast: Bool {
        contentViewModel.articles.isLast(article)
    }
    
    var isPageLoading: Bool {
        contentViewModel.isNewPageLoading
    }
    
    var urlToImage: String {
        article.urlToImage ?? ""
    }
    
    var title: String {
        article.title ?? ""
    }
    
    var description: String {
        article.articleDescription ?? ""
    }
    
    init(contentViewModel: ContentViewModel, article: ArticleModel) {
        self.contentViewModel = contentViewModel
        self.article = article
    }
}
