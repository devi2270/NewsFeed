//
//  ArticleDataManager.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 28/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

import Foundation

struct ArticleDataManager {
    
    static private let articleURL = URL(string: "https://no89n3nc7b.execute-api.ap-southeast-1.amazonaws.com/staging/exercise")
    
    static func fetchArticleDetails (completion: @escaping (String,[ArticleModel]) -> Void) {
        
        if let articleURL = articleURL {
            var networkOperator = NetworkOperator(url: articleURL)
            networkOperator.downloadDataFromURL { (jsonData) in
                let (title,articles) = self.parseArticleDetails(jsonData: jsonData)
                if let title = title {
                    if let articles = articles {
                        completion(title,articles)
                    }
                }
            }
        }
    }
    
    static private func parseArticleDetails(jsonData: Data?) -> (String?, [ArticleModel]?)  {
        
        let jsonDataDecoder = JSONDecoder()
        
        do {
            if let jsonData = jsonData {
                let jsonData = try jsonDataDecoder.decode(DataModel.self, from: jsonData)
                if let title = jsonData.title {
                    if let articles = jsonData.articles {
                        let sortedArticles = articles.sorted(by: { (article1, article2) -> Bool in
                            let title1 = article1.title ?? ""
                            let title2 = article2.title ?? ""
                            return (title1.localizedCaseInsensitiveCompare(title2) == .orderedDescending)
                        })
                        return (title, sortedArticles)
                    }
                }
            }
        } catch {
            print("Failed to decode JSON Data: \(error.localizedDescription)")
        }
        return (nil, nil)
    }
}   

