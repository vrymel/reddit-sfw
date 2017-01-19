//
//  EntryCommentsViewController.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 19/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit

class EntryCommentsViewController: UIViewController {
    
    private var _entry: EntryModel!
    
    @IBOutlet weak var postCommentsCount: UILabel!
    @IBOutlet weak var postOwner: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var entryThumbnail: UIImageView!
    @IBOutlet weak var subredditLabel: UILabel!
    
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

        titleLabel.text = entry.title
        postOwner.text = entry.owner
        postCommentsCount.text = "\(entry.commentsNumber) comments"
        subredditLabel.text = "/r/\(entry.subreddit)"
        
        do {
            let _entryUrl = URL(string: entry.thumbnailUrl)
            var imageData: Data
            
            try imageData = Data(contentsOf: _entryUrl!)
            
            entryThumbnail.image = UIImage(data: imageData)
        } catch {
            
        }
    }
    

}
