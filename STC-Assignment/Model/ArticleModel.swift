//
//  ContentModel.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 28/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

/*
    Struct containing all the data models.
*/

import Foundation

/*
    Model for the entire JSON data containing title and articles.
*/
struct DataModel: Codable {
    
    var title: String?
    var articles: [ArticleModel]?
}

/*
    Model for the articles.
*/
struct ArticleModel: Codable {
    
    var title: String?
    var website: String?
    var authors: String?
    var date: String?
    var content: String?
    var tag: Tag?
    var image_url: String?
}

/*
    Model for the tags of the articles.
*/
struct Tag: Codable {
    
    var id: Int?
    var label: String?
}

