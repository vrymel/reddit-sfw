//
//  ViewController.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 16/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SelectSubredditViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    
    private var entriesTitle = [EntryModel]()
    private var refreshControl: UIRefreshControl!
    private var presentingSubreddit: SubredditModel!
    private var cachedSubredditSelection = [SubredditModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar title stuff
        navigationController?.navigationBar.barTintColor            = UIColor(red: 0/255, green: 134/255, blue: 203/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes     = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.tintColor               = UIColor.white
        
        // pull to refresh stuff
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: UIControlEvents.valueChanged)
        tableView.addSubview(refreshControl)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchSubreddit()
    }
    
    func fetchSubreddit() {
        entriesTitle.removeAll()
        loadingIndicatorView.startAnimating()
        
        var subredditUrl = "/"
        var displayTitle = "front"
        if presentingSubreddit != nil {
            subredditUrl = presentingSubreddit.url
            displayTitle = presentingSubreddit.displayName
        }
        
        
        let url = URL(string: "http://reddit.com\(subredditUrl).json")
        DispatchQueue.global().async {
            Alamofire.request(url!).responseJSON { response in
                
                let entriesProcessed: [EntryModel] = self.processAPIResponse(response)
                
                if (entriesProcessed.count > 0) {
                    self.entriesTitle = entriesProcessed
                    self.tableView.reloadData()
                }
                
                self.refreshControl.endRefreshing()
                self.loadingIndicatorView.stopAnimating()
                self.navigationItem.title = displayTitle
            }
        }
        
    }
    
    func processAPIResponse(_ response: DataResponse<Any>) -> [EntryModel] {
        var processedEntries = [EntryModel]()
        
        if let rootKey = response.result.value as? Dictionary<String, AnyObject> {
            let data = rootKey["data"]
            
            if let entries = data?["children"] as? [Dictionary<String, AnyObject>] {
                for entry in entries {
                    if let entryData = entry["data"] as? Dictionary<String, AnyObject>, let em = createEntryObj(entryData) as EntryModel? {
                        processedEntries.append(em)
                    }
                }
            }
        }
        
        return processedEntries
    }
    
    func createEntryObj(_ entryData: Dictionary<String, AnyObject>) -> EntryModel? {
        let entryId             = entryData["id"] as? String
        let entrySubreddit      = entryData["subreddit"] as? String
        let entryTitle          = entryData["title"] as? String
        let entryThumbnailUrl   = entryData["thumbnail"] as? String
        let entryOwner          = entryData["author"] as? String
        let entryCommentsCount  = entryData["num_comments"] as? Int
        let entryIsSelf         = entryData["is_self"] as? Bool
        let entryUrl            = entryData["url"] as? String
        
        if entryTitle != nil && entryThumbnailUrl != nil {
            let em              = EntryModel(id: entryId!)
            em.subreddit        = entrySubreddit!
            em.title            = entryTitle!
            em.thumbnailUrl     = entryThumbnailUrl!
            em.owner            = entryOwner!
            em.commentsNumber   = entryCommentsCount!
            em.isSelf           = entryIsSelf!
            em.url              = entryUrl!
            
            return em
        }
        
        return nil
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
            if entriesTitle.count > indexPath.row {
                let showEntryTitle = self.entriesTitle[indexPath.row]
                cell.postCommentsCountBtn.tag = indexPath.row
                cell.postCommentsCountBtn.addTarget(self, action: #selector(ViewController.postCommentsAction(sender:)), for: .touchUpInside)
                cell.configureCell(entryData: showEntryTitle)
            
                return cell
            }
        }
        
        return EntryTableViewCell()
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry: EntryModel   = entriesTitle[indexPath.row]
        
        if entry.isSelf {
            viewEntryComments(fromModel: entry)
        } else {
            performSegue(withIdentifier: "ToExternalEntryURL", sender: entry)
        }
    }
    
    func postCommentsAction(sender: UIButton) {
        let entryIndex: Int = sender.tag
        
        viewEntryComments(fromIndex: entryIndex)
    }
    
    func viewEntryComments(fromIndex entryIndex: Int) {
        let entry: EntryModel   = entriesTitle[entryIndex]
        
        performSegue(withIdentifier: "ToEntryComments", sender: entry)
    }
    
    func viewEntryComments(fromModel entryModel: EntryModel) {
        performSegue(withIdentifier: "ToEntryComments", sender: entryModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EntryCommentsViewController {
            if let entry = sender as? EntryModel {
                destination.entry = entry
            }
        }
        
        if let destination = segue.destination as? ExternalEntryURLViewController {
            if let entry = sender as? EntryModel {
                destination.entry = entry
            }
        }
        
        if let destination = segue.destination as? SelectSubredditViewController {
            destination.delegate = self
            destination.cachedSubreddits = cachedSubredditSelection
        }
    }
    
    @IBAction func changeSubredditAction(_ sender: Any) {
        performSegue(withIdentifier: "ToSelectSubreddit", sender: nil)
    }
    
    func subredditSelected(_ subreddit: SubredditModel) {
        presentingSubreddit = subreddit
        
        fetchSubreddit()
    }
    
    func cacheSubredditSelection(_ subreddits: [SubredditModel]) {
        self.cachedSubredditSelection = subreddits
    }
}

