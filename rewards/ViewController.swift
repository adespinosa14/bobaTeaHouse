//
//  ViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 10/24/20.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var totalPoints = Int()
    var randomImage = [PFFileObject]()
    
    override func viewDidAppear(_ animated: Bool) {
        
        let query = PFQuery(className: "rewards")
        if let id = PFUser.current()?.objectId{
            query.whereKey("currentUser", equalTo: id)
        }
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print("Parse Error: \(String(describing: error))")
            }else{

                if let object = objects{
                    if object.count > 0{
                        for points in object{
                            print(points["points"]!)
                            self.totalPoints = points["points"] as! Int
                        }
                    }
                }
            }
        }
        print("Total Points \(totalPoints)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
