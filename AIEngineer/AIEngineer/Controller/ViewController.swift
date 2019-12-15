//
//  ViewController.swift
//  AIEngineer
//
//  Created by Kushal Mandala on 15/12/19.
//  Copyright © 2019 Indovations. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var postListTableView : UITableView!
    
    var refreshControl : UIRefreshControl = UIRefreshControl()
    var reqPage = 1
    var postInfo : PostInfo!
    var posts : [Post] = []
    var selectedPosts : [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView()
        self.requestPosts(page:self.reqPage)
        self.updateStatusBar(count: 0)
        
    }
    
    func updateStatusBar(count : NSInteger) {
        self.title = "Displaying Posts "+"\(count)"
    }

    
    func setupTableView() {
        self.postListTableView.register(UINib(nibName: "PostTableViewCell", bundle: .main), forCellReuseIdentifier: "PostCell")
        self.postListTableView.refreshControl = self.refreshControl
        self.refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Refresh Posts...")
    }

    
    @objc func refreshPosts() {
        self.reqPage = 1
        self.requestPosts(page: self.reqPage)
        self.refreshControl.endRefreshing()
    }
    
    func appendPosts(additionalPosts : [Post]) {
        for post in additionalPosts {
            self.posts.append(post)
        }
    }
    
    func requestPosts(page: Int) {
        let requestUrlString = SyncInfo.BASE_URL+"\(page)"
        Service.shared.requestPosts(url: requestUrlString) { (postInfo) in
            guard postInfo.hits.count > 0 else {
                self.postInfo = postInfo
                return
            }
            
            if (page == 1) {
                self.posts = postInfo.hits
            } else {
                self.appendPosts(additionalPosts: postInfo.hits)
            }
            
            DispatchQueue.main.async {
                self.postListTableView.reloadData()
                self.updateStatusBar(count: self.posts.count)
            }
        }
    }
}

extension ViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostTableViewCell
        
        let post = self.posts[indexPath.row]
        cell.postTitleLabel.text = post.title
        cell.postDateLabel.text = post.created_at
        
        if indexPath.row == self.posts.count-1 {
            self.reqPage += 1
            self.requestPosts(page: self.reqPage)
        }
        
        return cell
    }
    
    
}


