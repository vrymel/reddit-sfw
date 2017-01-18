//
//  EntryModel.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 17/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import Foundation

class EntryModel {
    var _title: String!
    var _thumbnailUrl: String!
    
    var title: String {
        if _title == nil {
            _title = ""
        }
        
        return _title
    }
    
    var thumbnailUrl: String {
        if _thumbnailUrl == nil {
            _thumbnailUrl = ""
        }
        
        return _thumbnailUrl
    }
    
    init(title: String, thumbnailUrl: String) {
        self._title = title
        self._thumbnailUrl = thumbnailUrl
    }
}
