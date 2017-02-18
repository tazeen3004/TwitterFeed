//
//  ViewController.swift
//  TwitterFeed
//
//  Created by Tazeen on 18/02/17.
//  Copyright © 2017 Tazeen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myTextField: UITextField!
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myLabel: UILabel!
    
    @IBAction func search(_ sender: UIButton)
    {
        if myTextField.text != ""
        {
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
                //get the name
                let webContent:String = String(data: data!, encoding :String.Encoding.utf8 )!
                var array:[String] = webContent.components(separatedBy: "<title>")
                array = array[1].components(separatedBy: " |")
                let name = array[0]
                array.removeAll()
                
                //get the profile pic
                array = webContent.components(separatedBy: "data-resolved-url-large=\"")
                array = array[1].components(separatedBy: "\"")
                let profilePicture = array[0]
                
                DispatchQueue.main.async
                {
                    self.myLabel.text = name
                    self.updateImage(url: profilePicture)
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

