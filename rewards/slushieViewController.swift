//
//  slushieViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/1/20.
//

import UIKit
import Parse

class slushieViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hamburgerMenuCons: NSLayoutConstraint!
    @IBOutlet weak var hamburgerBackground: UIView!
    @IBOutlet weak var mainMenuTable: UITableView!
    
    var hamburgerConstant = 0
    
    var teaNames = [String]()
    var teaPrice = [String]()
    var teaImage = [PFFileObject]()
    var slushieId = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        
        teaNames.removeAll()
        teaPrice.removeAll()
        teaImage.removeAll()
        
        let query = PFQuery(className: "slushies")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print("Parse Error: \(String(describing: error?.localizedDescription))")
            }else if let object = objects{
                for items in object{
                    if let item = items as? PFObject{
                        
                        if let name = item["drinkName"] as? String{
                            self.teaNames.append(name)
                        }else{
                            print("Names Not Found")
                        }
                        
                        if let price = item["price"] as? String{
                            self.teaPrice.append(price)
                        }else{
                            print("No Price Found")
                        }
                        
                        if let image = item["drinkImage"] as? PFFileObject{
                            self.teaImage.append(image)
                        }else{
                            print("No Image Data Found")
                        }
                        
                        if let id = item.objectId as? String{
                            self.slushieId.append(id)
                        }else{
                            print("No Id Found")
                        }
                        
                        self.mainMenuTable.reloadData()
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mainMenuTable.delegate = self
        mainMenuTable.dataSource = self
        hamburgerMenuCons.constant = -270
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teaNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! milkTeasTableViewCell
        
        teaImage[indexPath.row].getDataInBackground { (data, error) in
            
            if error != nil{
                print("Image Extraction Error: \(String(describing: error?.localizedDescription))")
            }else if let imageData = data{
                if let image = UIImage(data: imageData){
                    cell.drinkImage.image = image
                }
            }
            
        }
        
        cell.nameTitle.text = teaNames[indexPath.row]
        cell.price.text = teaPrice[indexPath.row]
        
        return cell
    }
    
    @IBAction func hamburgerPressed(_ sender: Any) {
        
        if hamburgerConstant == 0{
            
            hamburgerMenuCons.constant = 0
            hamburgerConstant = 1
            
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
            
        }else{
            hamburgerMenuCons.constant = -270
            hamburgerConstant = 0
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row Pressed: \(indexPath.row) \n Object Id: \(slushieId[indexPath.row])")
        UserDefaults.standard.setValue(slushieId[indexPath.row], forKey: "slushieId")
        
        performSegue(withIdentifier: "itemView", sender: nil)
    }
    
//MARK: Segues
    
    @IBAction func milkTea(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func flavoredTea(_ sender: Any) {
    }
    
    
    
}
