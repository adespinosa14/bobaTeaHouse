//
//  logInViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 11/18/20.
//

import UIKit
import Parse

class logInViewController: UIViewController {
    
    
    @IBOutlet weak var emailInput: UITextField!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var rememberSwitch: UISwitch!
    
    func createAlert(title: String, message: String, actionTitle: String){
            
            let newAlert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            newAlert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action) in
                newAlert.dismiss(animated: true, completion: nil)
            }))
            present(newAlert, animated: true, completion: nil)
            
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        
        if emailInput.text == "" || passwordInput.text == ""{
            
            createAlert(title: "Form Error", message: "Please complete all text fields", actionTitle: "OK")
            
        }else{
            
            PFUser.logInWithUsername(inBackground: emailInput.text!, password: passwordInput.text!) { (user, error) in
                
                if error != nil{
                    
                    self.view.isUserInteractionEnabled = true
                    
                    var errorDisplay = "Please try again later"
                    if let errorMessage = error?.localizedDescription{
                        
                        errorDisplay = errorMessage
                        
                    }
                    
                    self.createAlert(title: "Form Error", message: errorDisplay, actionTitle: "OK")
                    print(String(describing: error))
                    
                }else{
                    if self.rememberSwitch.isOn == true{
                        UserDefaults.standard.setValue(self.emailInput.text, forKey: "usernameSave")
                        UserDefaults.standard.setValue(self.passwordInput.text, forKey: "passwordSave")
                        self.performSegue(withIdentifier: "nextPage", sender: nil)
                        print("Logged In With Saved Items")
                    }else if self.rememberSwitch.isOn == false{
                        self.performSegue(withIdentifier: "nextPage", sender: self)
                        print("Logged In Without Saved Items")
                    }
                    
                }
                
            }
            
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let username = UserDefaults.standard.object(forKey: "usernameSave") as? String{
            emailInput.text = username
        }
        
        if let password = UserDefaults.standard.object(forKey: "passwordSave") as? String{
            passwordInput.text = password
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "backgroundImage")!)
    }
    
}
