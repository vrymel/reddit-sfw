//
//  ViewController.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 16/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var entriesTitle = [EntryModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let url = URL(string: "http://reddit.com/.json")
        
        Alamofire.request(url!).responseJSON { response in
            
            if let rootKey = response.result.value as? Dictionary<String, AnyObject> {
                
                let data = rootKey["data"]
                
                if let entries = data?["children"] as? [Dictionary<String, AnyObject>] {
                    
                    for entry in entries {
                        
                        if let entryData = entry["data"] as? Dictionary<String, AnyObject> {
                            
                            let entryTitle = entryData["title"] as? String
                            let entryThumbnailUrl = entryData["thumbnail"] as? String
                            
                            if entryTitle != nil && entryThumbnailUrl != nil {
                                //print("\(entryTitle) - \(entryThumbnailUrl)")
                                self.entriesTitle.append( EntryModel(title: entryTitle!, thumbnailUrl: entryThumbnailUrl!) )
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entriesTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "redditCell", for: indexPath) as? EntryTableViewCell {
            
            let showEntryTitle = self.entriesTitle[indexPath.row]
            
            cell.configureCell(entryData: showEntryTitle)
            
            return cell
        }
        
        return EntryTableViewCell()
        
    }

}

