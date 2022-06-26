//
//  foodViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/2/20.
//

import UIKit
import Parse

class foodViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var hamburgerMenuCons: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    var foodName = [String]()
    var foodPrice = [String]()
    var foodId = [String]()
    var foodImage = [PFFileObject]()
    
    var hamburgerConstant = 0
    
    override func viewDidAppear(_ animated: Bool) {
        
        foodName.removeAll()
        foodPrice.removeAll()
        foodImage.removeAll()
        
        let query = PFQuery(className: "food")
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                print("Parse Error: \(String(describing: error?.localizedDescription))")
            }else if let object = objects{
                for items in object{
                    if let item = items as? PFObject{
                        
                        if let mealName = item["mealName"] as? String{
                            self.foodName.append(mealName)
                        }else{
                            print("No Names Found")
                        }
                        
                        if let mealPrice = item["meanPrice"] as? String{
                            self.foodPrice.append(mealPrice)
                        }else{
                            print("No Prices Found")
                        }
                        
                        if let id = item.objectId as? String{
                            self.foodId.append(id)
                        }else{
                            print("No Food Id Found")
                        }
                        
                        if let mealImage = item["mealImage"] as? PFFileObject{
                            self.foodImage.append(mealImage)
                        }else{
                            print("No Images Found")
                        }
                        self.mainTableView.reloadData()
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mainTableView.delegate = self
        mainTableView.dataSource = self
        hamburgerMenuCons.constant = -250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return foodName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! milkTeasTableViewCell
        
        foodImage[indexPath.row].getDataInBackground { (data, error) in
            if error != nil{
                print("Image Extraction Error: \(String(describing: error?.localizedDescription))")
            }else if let imageData = data{
                if let newImage = UIImage(data: imageData){
                    cell.drinkImage.image = newImage
                }
            }
        }
        
        cell.nameTitle.text = foodName[indexPath.row]
        cell.price.text = foodPrice[indexPath.row]
        
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
        
        print("Index Row: \(indexPath.row) \n Food Id: \(foodId[indexPath.row])")
        UserDefaults.standard.setValue(foodId[indexPath.row], forKey: "foodId")
        performSegue(withIdentifier: "itemView", sender: nil)
    }
    
        //MARK: Segues
    
    @IBAction func milkTeasPressed(_ sender: Any) {
        
        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    
}
