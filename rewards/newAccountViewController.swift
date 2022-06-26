//
//  newAccountViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 11/18/20.
//

import UIKit
import Parse

class newAccountViewController: UIViewController {
    
    @IBOutlet weak var newEmailInput: UITextField!
    @IBOutlet weak var newPasswordInput: UITextField!
    @IBOutlet weak var reenterPasswordInput: UITextField!
    
    var activityIndicator = UIActivityIndicatorView()
    
    func createAlert(title: String, message: String, actionTitle: String){
        
        let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        newAlert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
            newAlert.dismiss(animated: true, completion: nil)
        }))
        present(newAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        if newEmailInput.text == "" || newPasswordInput.text == "" || reenterPasswordInput.text == ""{
            
            createAlert(title: "Form Error", message: "Please complete all text fields", actionTitle: "OK")
            
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.color = UIColor.gray
            activityIndicator.startAnimating()
            view.addSubview(activityIndicator)
            self.view.isUserInteractionEnabled = false

            
        }else{
            
            let user = PFUser()
            
            if newPasswordInput.text == reenterPasswordInput.text{
                user.username = newEmailInput.text
                user.email = newEmailInput.text
                user.password = newPasswordInput.text
                user.signUpInBackground { (success, error) in
                    
                    if error != nil{
                        
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        var errorDisplay = "Please try again later"
                        if let errorMessage = error?.localizedDescription{
                            
                            errorDisplay = errorMessage
                            
                        }
                        
                        self.createAlert(title: "Form Error", message: errorDisplay, actionTitle: "OK")
                        print(String(describing: error))
                        
                    }else{
                        
                        let rewards = PFObject(className: "rewards")
                        rewards["currentUser"] = PFUser.current()?.objectId
                        rewards["points"] = 0
                        rewards.saveInBackground()
                        
                        self.activityIndicator.stopAnimating()
                        self.view.isUserInteractionEnabled = true
                        
                        let successMessage = UIAlertController(title: "Account Successful", message: "Congratulations, your account was successfully created!", preferredStyle: UIAlertController.Style.alert)
                        successMessage.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        }))
                        self.present(successMessage, animated: true, completion: nil)
                        print("Success")
                    }
                    
                }
                
            }else{
                createAlert(title: "Form Error", message: "Passwords do not match", actionTitle: "OK")
            }
            
        }
        
    }
    
    @IBAction func haveAccountButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage")!)
    }
    
}
