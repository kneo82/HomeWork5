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
            loadPage()
        }
    }
    
    private let model: ArticlesListModel
    
    private var sourceIds = ["techcrunch", "cnn", "rbc", "lenta"]
    private(set) var sourceNames = ["TechCrunch", "CNN", "RBC", "Lenta"]
    
    init(articleListModel: ArticlesListModel) {
        self.model = articleListModel
    }
    
    func loadPage() {
        guard isNewPageLoading == false else {
            return
        }
        
        isNewPageLoading = true
        page += 1
        
        model.loadPage(source: sourceIds[sourceIndex], page: page) { [weak self] articles in
            self?.articles.append(contentsOf: articles)
            self?.isNewPageLoading = false
        }
    }
    
    func resetDataBase() {
        page = 0
        articles = [ArticleModel]()
        isNewPageLoading = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.model.clearDataBase()
            self.loadPage()
        }
    }
}
