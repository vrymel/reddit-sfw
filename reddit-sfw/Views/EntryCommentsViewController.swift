//
//  EntryCommentsViewController.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 19/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class EntryCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var _entry: EntryModel!
    private var comments = [CommentModel]()
    
    @IBOutlet weak var postCommentsCount: UILabel!
    @IBOutlet weak var postOwner: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var entryThumbnail: UIImageView!
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var commentsTableView: UITableView!
    
    var entry: EntryModel {
        get {
            return _entry
        }
        set {
            _entry = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentsTableView.delegate = self
        commentsTableView.dataSource = self

        prepareDisplay()
    }
    
    func prepareDisplay() {
        titleLabel.text         = entry.title
        postOwner.text          = entry.owner
        postCommentsCount.text  = "\(entry.commentsNumber) comments"
        subredditLabel.text     = "/r/\(entry.subreddit)"
        
        entryThumbnail.kf.setImage(with: URL(string: self.entry.thumbnailUrl))
        fetchComments()
    }
    
    func fetchComments() {
        let url = URL(string: "https://www.reddit.com/r/\(entry.subreddit)/comments/\(entry.id)/.json")
        
        DispatchQueue.global().async {
            Alamofire.request(url!).responseJSON { response in
                
                if let rootKey = response.result.value as? [AnyObject] {
                    //let data = rootKey["data"]
                    
                    
                    for list in rootKey {
                        
                        if let listing = list as? Dictionary<String, AnyObject> {
                            
                            self.processListing(listing: listing)
                        } else {
                            
                            print("cast failed")
                        }
                        
                        
                    }
                    
                    self.commentsTableView.reloadData()
                }
                
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentViewCell {
            
            let c = self.comments[indexPath.row]
            
            cell.configureCell(comment: c)
            
            return cell
        }
        
        return CommentViewCell()
    }
    
    func processListing(listing: Dictionary<String, AnyObject>) {
        
        if let data = listing["data"] as? Dictionary<String, AnyObject> {
            
            if let children = data["children"] as? [Dictionary<String, AnyObject>] {
                
                for child in children {
                    
                    if let kind = child["kind"] as? String, kind == "t1" {
                        
                        self.processComment(comment: child)
                    }
                }
            }
        }
        
    }
    
    func processComment(comment: Dictionary<String, AnyObject>) {
        
        let details: Dictionary<String, AnyObject> = (comment["data"] as? Dictionary<String, AnyObject>)!
        
        let cm = CommentModel()
        cm.author = details["author"] as! String
        cm.score = details["score"] as! Int
        cm.body = details["body"] as! String
        
        
        comments.append(cm)
    }
}
