//
//  CommentModel.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 20/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import Foundation

class CommentModel {
    
    private var _score: Int!
    private var _author: String!
    private var _body: String!
    
    var score: Int {
        get {
            return _score
        }
        set {
            _score = newValue
        }
    }
    
    var author: String {
        get {
            return _author
        }
        set {
            _author = newValue
        }
    }
    
    var body: String {
        get {
            return _body
        }
        set {
            _body = newValue
        }
    }
}
