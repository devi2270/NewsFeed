//
//  ContentModel.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 28/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

import Foundation

struct DataModel: Codable {
    
    var title: String?
    var articles: [ArticleModel]?
}

struct ArticleModel: Codable {
    
    var title: String?
    var website: String?
    var authors: String?
    var date: String?
    var content: String?
    var tag: Tag?
    var image_url: String?
}

struct Tag: Codable {
    
    var id: Int?
    var label: String?
}

