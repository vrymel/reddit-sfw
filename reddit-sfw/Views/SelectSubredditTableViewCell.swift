//
//  SelectSubredditTableViewCell.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 26/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit

class SelectSubredditTableViewCell: UITableViewCell {

    @IBOutlet weak var subredditText: UILabel!
    
    func configureCell(subreddit: SubredditModel) {
        subredditText.text = subreddit.displayName
    }
}
