//
//  ContentViewModel.swift
//  HomeWork5
//
//  Created by Vitaliy Voronok on 17.04.2020.
//  Copyright © 2020 Vitaliy Voronok. All rights reserved.
//

import Foundation

final public class ContentViewModel: ObservableObject {
    
    @Published private(set) var articles = [ArticleModel]()
    @Published var page: Int = 0
    @Published var isNewPageLoading = false
    @Published var sourceIndex: Int = 0 {
        didSet {
            page = 0
            articles = [ArticleModel]()
            isNewPageLoading = false
//            pageLoad(forceReload: false)
            loadPage()
            print("---- select \(sourceNames[sourceIndex])")
        }
    }
    
    private let model: ArticlesListModel
    private var sourceIds = ["techcrunch", "cnn", "rbc", "lenta"]
    private(set) var sourceNames = ["TechCrunch", "CNN", "RBC", "Lenta"]
    
    private(set) var locator: ServiceLocator?

    init(articleListModel: ArticlesListModel, serviceLocator: ServiceLocator?) {
        self.model = articleListModel
        self.locator = serviceLocator
    }
    
    func loadPage() {
        guard locator != nil, isNewPageLoading == false else {
            return
        }
        
        isNewPageLoading = true
        page += 1
        
        if let service = locator?.getServiceOf(ArticlesService.self)  {
            service.getArticles(source: sourceIds[sourceIndex], page: page) { [weak self] articles in
                self?.articles.append(contentsOf: articles)
                self?.isNewPageLoading = false
            }
        }
    }
}
