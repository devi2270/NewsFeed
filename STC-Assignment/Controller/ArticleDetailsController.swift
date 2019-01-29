//
//  ArticleDetailsController.swift
//  STC-Assignment
//
//  Created by Devi Prasad Ganta on 28/01/19.
//  Copyright © 2019 Self LearningSelf. All rights reserved.
//

import UIKit

class ArticleDetailsController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var selectedArticle: ArticleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //self.titleLabel.semanticContentAttribute = .forceRightToLeft
        //self.contentLabel.semanticContentAttribute = .forceRightToLeft
        
        self.titleLabel.text = selectedArticle?.title
        self.contentLabel.text = selectedArticle?.content
        if let urlString = selectedArticle?.image_url {
            if let url = URL(string: urlString) {
                if let imageData = NSData(contentsOf: url) as Data? {
                    self.imageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
