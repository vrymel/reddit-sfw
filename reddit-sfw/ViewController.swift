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
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 53/255, green: 165/255, blue: 187/255, alpha: 0.3)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor = UIColor.white

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchSubreddit()
        
    }
    
    func fetchSubreddit() {
        
        entriesTitle.removeAll()
        
        let url = URL(string: "http://reddit.com/.json")
        
        DispatchQueue.global().async {
            Alamofire.request(url!).responseJSON { response in
                
                if let rootKey = response.result.value as? Dictionary<String, AnyObject> {
                    
                    let data = rootKey["data"]
                    
                    if let entries = data?["children"] as? [Dictionary<String, AnyObject>] {
                        
                        for entry in entries {
                            
                            if let entryData = entry["data"] as? Dictionary<String, AnyObject> {
                                
                                let entryId = entryData["id"] as? String
                                let entrySubreddit = entryData["subreddit"] as? String
                                let entryTitle = entryData["title"] as? String
                                let entryThumbnailUrl = entryData["thumbnail"] as? String
                                let entryOwner = entryData["author"] as? String
                                let entryCommentsCount = entryData["num_comments"] as? Int
                                
                                if entryTitle != nil && entryThumbnailUrl != nil {
                                    
                                    let em = EntryModel(id: entryId!)
                                    em.subreddit = entrySubreddit!
                                    em.title = entryTitle!
                                    em.thumbnailUrl = entryThumbnailUrl!
                                    em.owner = entryOwner!
                                    em.commentsNumber = entryCommentsCount!
                                    
                                    self.entriesTitle.append(em)
                                }
                            }
                        }
                        
                        self.refreshControl.endRefreshing()
                        self.tableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    func refresh(sender: AnyObject) {
        
        fetchSubreddit()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entryIndex: Int = indexPath[1]
        let entry: EntryModel = entriesTitle[entryIndex]
        
        performSegue(withIdentifier: "ToEntryComments", sender: entry)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntryCommentsViewController {
            if let entry = sender as? EntryModel {
                destination.entry = entry
            }
        }
    }
}

