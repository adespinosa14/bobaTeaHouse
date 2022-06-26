//
//  titleViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 11/19/20.
//

import UIKit
import Parse

class titleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if PFUser.current() != nil{
            print("User Logged In")
            performSegue(withIdentifier: "nextPage", sender: self)
        }
    }
    
}
