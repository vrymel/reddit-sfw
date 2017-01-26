//
//  EntryModel.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 17/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import Foundation

class EntryModel {
    
    private var _id: String!
    private var _subreddit: String!
    private var _title: String!
    private var _thumbnailUrl: String!
    private var _owner: String!
    private var _commentsNumber: Int!
    private var _isSelf: Bool! = true
    private var _url: String!
    
    var id: String {
        get {
            return _id
        }
    }
    var subreddit: String {
        get {
            if _subreddit == nil {
                _subreddit = ""
            }
            
            return _subreddit
        }
        set(newValue) {
            _subreddit = newValue
        }
    }
    var title: String {
        get {
            if _title == nil {
                _title = ""
            }
        
            return _title
        }
        set(newValue) {
            _title = newValue
        }
    }
    var thumbnailUrl: String {
        get {
            if _thumbnailUrl == nil {
                _thumbnailUrl = ""
            }
        
            return _thumbnailUrl
        }
        set(newValue) {
            _thumbnailUrl = newValue
        }
    }
    var owner: String {
        get {
            if _owner == nil {
                _owner = ""
            }
        
            return _owner
        }
        set(newValue) {
            _owner = newValue
        }
    }
    var commentsNumber: Int {
        get {
            if _commentsNumber == nil {
                _commentsNumber = 0
            }
            
            return _commentsNumber
        }
        set(newValue) {
            _commentsNumber = newValue
        }
    }
    var isSelf: Bool {
        get {
            return _isSelf
        }
        set(newValue) {
            _isSelf = newValue
        }
    }
    var url: String {
        get {
            return _url
        }
        set(newValue) {
            _url = newValue
        }
    }
    
    
    init(id: String) {
        _id = id
    }
}
