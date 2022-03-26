//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Blaine Beltran on 3/24/22.
//

import UIKit
import Parse

class FeedViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!
    
    var feedPosts = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        postTableView.delegate = self
        postTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let query = PFQuery(className: "Posts")
        query.includeKey("author")
        query.limit = 20
        
        query.findObjectsInBackground { [weak self] (posts, error) in
            
            guard let strongSelf = self else { return }
            
            if let error = error {
                strongSelf.displayFetchingPostsError(error: error)
            }
            
            guard posts != nil else {
                fatalError()
            }
            
            strongSelf.feedPosts = posts!
            
            DispatchQueue.main.async {
                strongSelf.postTableView.reloadData()
            }
        }
    }
    
    private func displayFetchingPostsError(error: Error) {
        
        let title = NSLocalizedString("Fetching Error", comment: "Title for fetch failure alert")
        let message = NSLocalizedString("Oops! Something went wrong while trying to fetch posts. \(error.localizedDescription)", comment: "Message for sign up failure alert")
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        
        let actionTitle = NSLocalizedString("OK", comment: "OK action title")
        let OKAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        present(alertController, animated: true, completion: nil)
        
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        let post = feedPosts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.postUsernameLabel.text = user.username
        cell.postCaptionLabel.text = post["caption"] as? String
        
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)
        
        cell.postImageView.af.setImage(withURL: url!)
        
        return cell
    }
    
    
    
}
