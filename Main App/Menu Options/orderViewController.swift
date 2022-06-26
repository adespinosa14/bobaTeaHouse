//
//  orderViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 11/18/20.
//

import UIKit
import Parse
import SquareInAppPaymentsSDK

class orderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainOrderView: UITableView!
    @IBOutlet weak var hamburgerMenuCons: NSLayoutConstraint!
    @IBOutlet weak var haburgerBackground: UIView!
    
    var hamburgerConstant = 0
    
    var teaPrice = [String]()
    var teaName = [String]()
    var teaID = [String]()
    var teaImage = [PFFileObject]()
    
    var objectCount = Int()
    var isActive = Bool()
    
    var i = 0
    var newObject = [UITableViewCell]()
    
    override func viewDidAppear(_ animated: Bool) {
        
        teaPrice.removeAll()
        teaName.removeAll()
        teaImage.removeAll()
        
        let query = PFQuery(className: "milkTeas")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print("Parse Error: \(String(describing: error))")
            }else{
                if let object = objects{
                    for items in object{
                        if let item = items as? PFObject{
                            
                            if let description = item["Description"] as? String{
                                self.teaPrice.append(description)
                            }else{
                                print("Description Not Found")
                            }
                            
                            if let name = item["teaName"] as? String{
                                self.teaName.append(name)
                            }else{
                                print("Item Not Found")
                            }
                            
                            if let newId = item.objectId as? String{
                                
                                self.teaID.append(newId)
                                print("objectID: \(newId)")
                                
                            }else{
                                print("No ID Extracted")
                            }
                            
                            if let image = item["fileImage"] as? PFFileObject{
                                
                                self.teaImage.append(image)
                                
                            }else{
                                print("Image Not Found")
                            }
                            
                            self.mainOrderView.reloadData()
                        }
                    }
                }
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainOrderView.delegate = self
        mainOrderView.dataSource = self
        hamburgerMenuCons.constant = -250
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teaPrice.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! milkTeasTableViewCell
        
        teaImage[indexPath.row].getDataInBackground { (data, error) in
            if error != nil{
                print("Parse Image Extraction Error: \(String(describing: error?.localizedDescription))")
                cell.drinkImage.isHidden = true
            }else{
                if let imageData = data{
                    
                    if let image = UIImage(data: imageData){
                        cell.drinkImage.image = image
                    }
                }
            }
        }
        
        cell.nameTitle.text = teaName[indexPath.row]
        cell.price.text = teaPrice[indexPath.row]
        
        return cell
    }
    
    @IBAction func hamburgerPressed(_ sender: Any) {
        
        if hamburgerConstant == 0{
            hamburgerMenuCons.constant = 0
            hamburgerConstant = 1
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
        }else{
            hamburgerMenuCons.constant = -250
            hamburgerConstant = 0
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row Pressed: \(indexPath.row)")
        print("Tea ID: \(teaID)")
        
        let id = teaID[indexPath.row]
        
        UserDefaults.standard.setValue(id, forKey: "itemID")
        performSegue(withIdentifier: "itemView", sender: nil)
        
    }
    
//MARK: Segues
    
    @IBAction func flavoredTeaPressed(_ sender: Any) {
        
        hamburgerMenuCons.constant = -250
        hamburgerConstant = 0
        
    }
    
    @IBAction func slushiePressed(_ sender: Any) {
        
        hamburgerMenuCons.constant = -250
        hamburgerConstant = 0
        
    }
    
    
}
