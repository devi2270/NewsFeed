//
//  JSONDataModel.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 30/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

/* *** IMPORTANT ***
 Model Classes based on Realm and Codable.
 This file is not being used currently due to parsing issue.
 ArticleModel.swift is used for the Models instead.
*/

import Foundation
import Realm
import RealmSwift

class RealmDataModel: Object, Decodable {
    
    @objc dynamic var title: String = ""
    var articles = List<RealmArticleModel>()
    
    private enum JSONDataCodingKeys: String, CodingKey {
        case title
        case articles
    }
    
    convenience init(title: String, articles: List<RealmArticleModel>) {
        self.init()
        self.title = title
        self.articles = articles
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: JSONDataCodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let articles = try container.decode([RealmArticleModel].self, forKey: .articles)
        let articlesList = List<RealmArticleModel>()
        articlesList.append(objectsIn: articles)
        self.init(title: title, articles: articlesList)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}

class RealmArticleModel: Object, Decodable {
    
    @objc dynamic var title: String = ""
    @objc dynamic var website: String = ""
    @objc dynamic var authors: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var content: String = ""
    var tags = List<RealmTag>()
    @objc dynamic var image_url: String = ""
    
    private enum ArticleDataCodingKeys: String, CodingKey {
        case title
        case website
        case authors
        case date
        case content
        case tags
        case image_url
    }
    
    convenience init(title: String, website: String, authors: String, date: String, content: String, tags: List<RealmTag>, image_url: String) {
        self.init()
        self.title = title
        self.website = website
        self.authors = authors
        self.date = date
        self.content = content
        self.tags = tags
        self.image_url = image_url
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ArticleDataCodingKeys.self)
        let title = try container.decode(String.self, forKey: .title)
        let website = try container.decode(String.self, forKey: .website)
        let authors = try container.decode(String.self, forKey: .authors)
        let date = try container.decode(String.self, forKey: .date)
        let content = try container.decode(String.self, forKey: .content)
        let tags = try container.decode([RealmTag].self, forKey: .tags)
        let tagsList = List<RealmTag>()
        tagsList.append(objectsIn: tags)
        let image_url = try container.decode(String.self, forKey: .image_url)
        self.init(title: title, website: website, authors: authors, date: date, content: content,tags: tagsList, image_url: image_url)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}


class RealmTag: Object, Decodable {
    
    var id: Int?
    var label: String?
    
    private enum TagDataCodingKeys: String, CodingKey {
        case id
        case label
    }
    
    convenience init(id: Int, label: String) {
        self.init()
        self.id = id
        self.label = label
    }
    
    convenience required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: TagDataCodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let label = try container.decode(String.self, forKey: .label)
        
        self.init(id: id, label: label)
    }
    
    required init() {
        super.init()
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
}


