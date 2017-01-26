//
//  SelectSubredditViewController.swift
//  reddit-sfw
//
//  Created by Vrymel Omandam on 26/01/2017.
//  Copyright © 2017 Vrymel Omandam. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class SelectSubredditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingIndicatorView: NVActivityIndicatorView!
    
    var delegate: SelectSubredditViewControllerDelegate?
    var cachedSubreddits: [SubredditModel]?
    
    private var subreddits = [SubredditModel]()
    private var defaultSubredditsUrl = URL(string: "https://www.reddit.com/subreddits/.json")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if cachedSubreddits!.count > 0 {
            subreddits = cachedSubreddits!
        } else {
            fetchDefaultSubreddits()
        }
    }

    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchDefaultSubreddits() {
        loadingIndicatorView.startAnimating()
        
        DispatchQueue.global().async {
            Alamofire.request(self.defaultSubredditsUrl!).responseJSON { response in
                
                let processedSubreddits: [SubredditModel] = self.processAPIResponse(response)
                
                self.loadingIndicatorView.stopAnimating()
                self.subreddits = processedSubreddits
                self.tableView.reloadData()
                self.delegate?.cacheSubredditSelection(self.subreddits)
            }
        }
    }
    
    func processAPIResponse(_ response: DataResponse<Any>) -> [SubredditModel] {
        var processedSubreddit = [SubredditModel]()
        
        if let rootKey = response.result.value as? Dictionary<String, AnyObject> {
            let data = rootKey["data"]
            
            if let subreddits = data?["children"] as? [Dictionary<String, AnyObject>] {
                for subredditsRaw in subreddits {
                    if let subData = subredditsRaw["data"] as? Dictionary<String, AnyObject>, let sm = createSubredditObj(subData) as SubredditModel? {
                        
                        processedSubreddit.append(sm)
                    }
                }
            }
        }
        
        return processedSubreddit
    }
    
    func createSubredditObj(_ subredditData: Dictionary<String, AnyObject>) -> SubredditModel {
        let subTitle            = subredditData["title"] as? String
        let subUrl              = subredditData["url"] as? String
        let subDisplayName      = subredditData["display_name"] as! String
        
        let sm          = SubredditModel()
        sm.title        = subTitle!
        sm.url          = subUrl!
        sm.displayName  = subDisplayName
    
        return sm
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subreddits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "selectSubredditCell", for: indexPath) as? SelectSubredditTableViewCell {
            
            cell.configureCell(subreddit: subreddits[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedSubreddit = subreddits[indexPath.row]
        
        delegate?.subredditSelected(selectedSubreddit)
        dismiss(animated: true, completion: nil)
    }
}

protocol SelectSubredditViewControllerDelegate {
    func subredditSelected(_ subreddit: SubredditModel)
    func cacheSubredditSelection(_ subreddits: [SubredditModel])
}
