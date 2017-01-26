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
    @IBOutlet weak var subredditLabel: UILabel!
    @IBOutlet weak var postCommentsCountBtn: UIButton!
    
    func configureCell(entryData: EntryModel) {
        subredditLabel.text         = "/r/\(entryData.subreddit)"
        titleLabel.text             = entryData.title
        postOwner.text              = entryData.owner
        postCommentsCountBtn.setTitle("\(entryData.commentsNumber) comments"
, for: .normal)
        
        let thumbnailUrl            = URL(string: entryData.thumbnailUrl)
        let placeholderThumbnail    = UIImage(named: "reddit-alien.png")
        
        entryThumbnail.kf.setImage(with: thumbnailUrl, placeholder: placeholderThumbnail)
    }

}
