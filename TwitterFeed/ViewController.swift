//
//  ViewController.swift
//  TwitterFeed
//
//  Created by Tazeen on 18/02/17.
//  Copyright © 2017 Tazeen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
  
    
    
    @IBOutlet weak var myTableView: UITableView!
       
    var tweets:[String] = []
    
    //Activity indicator
    var activityIndicator = UIActivityIndicatorView()
    
    func startA()
    {
        UIApplication.shared.beginIgnoringInteractionEvents()
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    //Setting table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
                return tweets.count
    
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MyTableViewCell
        cell.myTextView.text = tweets[indexPath.row]
        return cell
    
    }
    
    
    
    
    
    
    
    @IBAction func search(_ sender: UIButton)
    {
        if myTextField.text != ""
        {
            startA()
            let user = myTextField.text?.replacingOccurrences(of: " ", with: "")
            getStuff(user: user!)
            
        }
    }

    // creating function which will get all info
    
    func getStuff(user: String)
    {
        let url = URL(string: "https://twitter.com/" + user)
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil
            {
                DispatchQueue.main.async {
                    
                
                if let errorMessage = error?.localizedDescription
                {
                    self.myLabel.text = errorMessage
                }
                else
                {
                    self.myLabel.text = "There has been an error try again later"
                }
                }
            }
            else
            {
                
                let webContent:String = String(data: data!, encoding :String.Encoding.utf8 )!
                
                if webContent.contains("<title>") && webContent.contains("data-resolved-url-large=\"")
                {
                    //gets the name
                    var array:[String] = webContent.components(separatedBy: "<title>")
                    array = array[1].components(separatedBy: " |")
                    let name = array[0]
                    array.removeAll()
            
                
                    
                    //get the profile pic
                    array = webContent.components(separatedBy: "data-resolved-url-large=\"")
                    array = array[1].components(separatedBy: "\"")
                    let profilePicture = array[0]
                    
                    //GET THE TWEETS
                    array = webContent.components(separatedBy: "data-aria-label-part=\"0\">")
                    array.remove(at: 0)
                    for i in 0...array.count-1
                    {
                        let newTweet = array[i].components(separatedBy: "<")
                        array[i] = newTweet[0]
                       
                    }
                    
                    self.tweets = array
                    
                    DispatchQueue.main.async
                        {
                            self.myLabel.text = name
                            self.updateImage(url: profilePicture)
                            self.myTableView.reloadData()
                            self.activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                    }
                    
                    
                    
                }
                else
                {
                    DispatchQueue.main.async {
                    
                    self.myLabel.text = "Sorry couldn't find the user"
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()                    }
                    }
                    
                
            }
        
        
        }
        task.resume()
    }
    
    func updateImage(url :String)
    {
        let url = URL(string: url)
            
        let task = URLSession.shared.dataTask(with: url!) {  (data, response, error) in
            DispatchQueue.main.async {
                self.myImageView.image = UIImage(data: data!)
            }
        
        }
        task.resume()
    }
        
        
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

