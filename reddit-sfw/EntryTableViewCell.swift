//
//  EntryTableViewCell.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 17/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var entryThumbnail: UIImageView!
    
    func configureCell(entryData: EntryModel) {
        titleLabel.text = entryData.title
        
        do {
            print("configureCell - \(entryData.thumbnailUrl)")
            let _entryUrl = URL(string: entryData.thumbnailUrl)
            var imageData: Data
            
            try imageData = Data(contentsOf: _entryUrl!)
            
            entryThumbnail.image = UIImage(data: imageData)
        } catch {
            
        }
    }

}
