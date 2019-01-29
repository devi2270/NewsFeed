//
//  NetworkOperator.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 28/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

import Foundation

struct NetworkOperator {
    
    lazy var configuration: URLSessionConfiguration = URLSessionConfiguration.default
    lazy var session: URLSession = URLSession(configuration:self.configuration)
    var URL: URL
    
    typealias CompletionType = (Data?) -> Void
    
    init(url: URL) {
        self.URL = url
    }
    
    /*
     Downloads json from the URL;
     convert it to NSData and
     returns the dictionary
     */
    mutating func downloadDataFromURL(completion: @escaping CompletionType) {
        
        let request = URLRequest(url: self.URL)
        
        let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                completion(data)
        });
        task.resume()
    }
    
}
