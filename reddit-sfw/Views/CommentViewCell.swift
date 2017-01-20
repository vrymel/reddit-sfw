//
//  CommentViewCell.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 20/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit

class CommentViewCell: UITableViewCell {
    @IBOutlet weak var authorPointsLabel: UILabel!
    @IBOutlet weak var commentBody: UILabel!
    
    func configureCell(comment: CommentModel) {
        authorPointsLabel.text = "\(comment.author) - \(comment.score) points"
        commentBody.text = comment.body
    }
}
