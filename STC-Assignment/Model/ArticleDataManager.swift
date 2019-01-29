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
            networkOperator.downloadDataFromURL { (jsonDict) in
                let (title,articles) = self.parseArticleDetails(jsonDictionary: jsonDict)
                if let title = title {
                    if let articles = articles {
                        completion(title,articles)
                    }
                }
            }
        }
    }
    
    static private func parseArticleDetails(jsonDictionary: [String: AnyObject]?) -> (String?, [ArticleModel]?)  {
        
        var articles = [ArticleModel]()
        guard let  articlesArray = jsonDictionary?["articles"],
                let title = jsonDictionary?["title"] as? String
            else {
                print("No data returned from server!")
                return (nil, nil)
        }
        
        for var item in (articlesArray as? [[String: AnyObject]])! {
            var model = ArticleModel()
            model.title = item["title"] as? String
            model.content = item["content"] as? String
            model.imageURL = item["image_url"] as? String
            articles.append(model)
        }
    
        return (title,articles)
    }
}
