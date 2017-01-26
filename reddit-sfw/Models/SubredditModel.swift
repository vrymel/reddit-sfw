//
//  SubredditModel.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 26/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import Foundation

class SubredditModel {
    private var _title: String!
    private var _url: String!
    private var _displayName: String!
    
    var title: String {
        get {
            return _title
        }
        set(newValue) {
            _title = newValue
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
    
    var displayName: String {
        get {
            return _displayName
        }
        set(newValue) {
            _displayName = newValue
        }
    }
    
    
}
