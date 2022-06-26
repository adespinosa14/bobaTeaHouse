//
//  profileViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 11/20/20.
//

import UIKit
import Parse

class profileViewController: UIViewController {
    
    @IBOutlet weak var ClaudineView:UIView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        let person = PFUser.current()
        if let username = person?.email{
            let secondChance = UIAlertController(title: "Logout", message: "Are you sure you want to logout of: \(username)", preferredStyle: UIAlertController.Style.alert)
        
            secondChance.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
                secondChance.dismiss(animated: true, completion: nil)
            }))
        
            secondChance.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { (action) in
                PFUser.logOut()
                self.dismiss(animated: true, completion: nil)
            }))
        
            present(secondChance, animated: true, completion: nil)
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ClaudineView.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage")!)
        
        let person = PFUser.current()
        
        emailLabel.text = person!.email
        passwordLabel.text = String(describing: person!.password)
        //print("Password: \(String(describing: person!.password))")
        
    }
    
}
