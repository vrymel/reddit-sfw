//
//  EntryTableViewCell.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 17/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit
import Kingfisher

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var entryThumbnail: UIImageView!
    @IBOutlet weak var postOwner: UILabel!
    @IBOutlet weak var postCommentsCount: UILabel!
    @IBOutlet weak var subredditLabel: UILabel!
    
    func configureCell(entryData: EntryModel) {
        subredditLabel.text         = "/r/\(entryData.subreddit)"
        titleLabel.text             = entryData.title
        postOwner.text              = entryData.owner
        postCommentsCount.text      = "\(entryData.commentsNumber) comments"
        
        let thumbnailUrl            = URL(string: entryData.thumbnailUrl)
        let placeholderThumbnail    = UIImage(named: "doge-default.png")
        
        entryThumbnail.kf.setImage(with: thumbnailUrl, placeholder: placeholderThumbnail)
    }

}
