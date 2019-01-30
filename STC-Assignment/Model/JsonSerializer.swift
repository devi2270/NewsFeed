//
//  JsonSerializer.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 30/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

/* *** IMPORTANT ***
    JSON Serializer to decode the data and convert to data models.
    This file is not being used currently due parsing issue.
    ArticleDataManager.swift is used instead.
*/

import Foundation
import RealmSwift

class JSONSerializer {
    static func serialize(inputData: Data, sourceName: String) {
        let jsonDecoder = JSONDecoder()
        do {
            let json = try JSONSerialization.jsonObject(with: inputData, options: .allowFragments)
            guard json is [String:AnyObject] else {
                assert(false, "Could not parse data!")
                return
            }
            do {
                switch sourceName {
                case "Articles":
                    let articles = try jsonDecoder.decode([RealmArticleModel].self, from: inputData)
                    let realm = try! Realm()
                    for article in articles {
                        try! realm.write {
                            realm.add(article)
                        }
                    }
                case "Tags":
                    let tags = try jsonDecoder.decode([RealmTag].self, from: inputData)
                    let realm = try! Realm()
                    for tag in tags {
                        try! realm.write {
                            realm.add(tag)
                        }
                    }
                default:
                    let dataModels = try jsonDecoder.decode([RealmDataModel].self, from: inputData)
                    let realm = try! Realm()
                    for dataModel in dataModels {
                        try! realm.write {
                            realm.add(dataModel)
                        }
                    }
                }
            } catch {
                print("Could not convert data!")
            }
        } catch let error {
            print(error)
        }
    }
}
