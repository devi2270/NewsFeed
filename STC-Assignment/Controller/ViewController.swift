//
//  ViewController.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 28/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableview: UITableView!
    
    var articles = [ArticleModel]()
    var cache:NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.cache = NSCache()
        
        ArticleDataManager.fetchArticleDetails { (title,articlesArray) in
            self.articles = articlesArray
            DispatchQueue.main.async {
                self.title = title
                self.tableview.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cell"
        let article = articles[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ArticleCell
        cell?.titleLabel.text = article.title
        cell?.contentLabel.text = article.content
        
        cell?.articleImageView?.image = UIImage(named: "article-placeholder.png")
        
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            cell?.articleImageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }else{
            let session = URLSession.shared
            var task = URLSessionDownloadTask()
            
            let articleUrl = article.image_url
            if let articleUrl = articleUrl {
                let url = URL.init(string: articleUrl)
                //let url = URL(string: articleUrl)
                if let url = url {
                    task = session.downloadTask(with: url, completionHandler: { (data, response, error) -> Void in
                        if let data = try? Data(contentsOf: url){
                            DispatchQueue.main.async(execute: { () -> Void in
                                if let updateCell = tableView.cellForRow(at: indexPath) as? ArticleCell {
                                    let img:UIImage! = UIImage(data: data)
                                    updateCell.articleImageView?.image = img
                                    self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                                }
                            })
                        }
                    })
                    task.resume()
                }
            }
        }
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            
            let row = tableview.indexPathForSelectedRow?.row
            if let row = row {
                let detailVC = segue.destination as? ArticleDetailsController
                detailVC?.selectedArticle = articles[row]
            }
        }
    }

    @IBAction func refreshTapped(_ sender: Any) {
        ArticleDataManager.fetchArticleDetails { (title,articlesArray) in
            self.articles = articlesArray
            DispatchQueue.main.async {
                self.title = title
                self.tableview.reloadData()
            }
        }
    }
    
}
