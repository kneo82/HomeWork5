//
//  ArticlesListModel.swift
//  HomeWork5
//
//  Created by Vitaliy Voronok on 17.04.2020.
//  Copyright © 2020 Vitaliy Voronok. All rights reserved.
//

import Foundation
import RealmSwift

final public class ArticlesListModel {
    let realm = try? Realm()
    let serviceLocator: ServiceLocator?
    
    init(serviceLocator: ServiceLocator?) {
        self.serviceLocator = serviceLocator
    }
    
    func clearDataBase() {
        do {
            guard let data = realm?.objects(ArticleModel.self), data.count > 0 else {
                return
            }
            
            try realm?.write {
                realm?.deleteAll()
            }
            
        } catch {
            print("Can't delete data")
            print(error.localizedDescription)
        }
    }
    
    func loadPage(source: String,
                  page: Int,
                  completion: @escaping (_ articles: [ArticleModel]) -> Void)
    {
        if let articles = self.readCache(source: source, page: page) {
            completion(articles)
            return
        } else if let service = serviceLocator?.getServiceOf(ArticlesService.self)  {
            service.getArticles(source: source, page: page) { [weak self] articles in
                completion(articles)
                
                if !articles.isEmpty {
                    DispatchQueue.main.async {
                        guard let self = self else {
                            return
                        }
                        
                        do {
                            self.realm?.beginWrite()
                            self.realm?.add(articles)
                            try self.realm?.commitWrite()
                        } catch {
                            print("Can't save to Data Base")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        } else {
            completion([ArticleModel]())
        }
    }
    
    private func readCache(source: String, page: Int) -> [ArticleModel]? {
        guard let result = realm?.objects(ArticleModel.self).filter("sourceId == %@ AND page == %@", source, page), result.count > 0 else {
            return nil
        }
        
        return Array(result)
    }
}
