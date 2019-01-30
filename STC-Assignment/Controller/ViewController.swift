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
        
        /*
            Support Right To Left. Setting view appearnce  based on Layout Direction
        */
        let attribute = self.view.semanticContentAttribute
        let layoutDirection = UIView.userInterfaceLayoutDirection(for: attribute)
        if layoutDirection == .rightToLeft {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        else{
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        
        self.cache = NSCache()
        
        /*
            Calls the fetch API of the DataManager and updates the UI on the main thread.
        */
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
        
        /*
            Setting a placeholder image for all the image cells.
        */
        cell?.articleImageView?.image = UIImage(named: "article-placeholder.png")
        
        /*
            Loading the already cached image if exists.
        */
        if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
            cell?.articleImageView?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        }
        
        /*
            Image not available in cache, downloads the images only for visible cells.
        */
        else{
            let session = URLSession.shared
            var task = URLSessionDownloadTask()
            
            let articleUrl = article.image_url
            if let articleUrl = articleUrl {
                let url = URL.init(string: articleUrl)
                //let url = URL(string: articleUrl)
                if let url = url {
                    task = session.downloadTask(with: url, completionHandler: { (data, response, error) -> Void in
                        if let data = try? Data(contentsOf: url){
                            /*
                                Updates the cell images in the main thread.
                            */
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
    
    /*
        Sending the selected article to the details screen.
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailSegue") {
            
            let row = tableview.indexPathForSelectedRow?.row
            if let row = row {
                let detailVC = segue.destination as? ArticleDetailsController
                detailVC?.selectedArticle = articles[row]
            }
        }
    }

    /*
        Action function for the refresh button. Refreshes the data when tapped.
    */
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
