//
//  handcraftedEspressoViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/1/20.
//

import UIKit
import Parse

class handcraftedEspressoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hamburgerMenuCons: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    var drinkNames = [String]()
    var drinkPrices = [String]()
    var esId = [String]()
    var drinkImages = [PFFileObject]()
    
    var hamburgerConstant = 0
    
    override func viewDidAppear(_ animated: Bool) {
        
        drinkNames.removeAll()
        drinkPrices.removeAll()
        drinkImages.removeAll()
        
        let query = PFQuery(className: "handcraftedEspresso")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print("Parse Error: \(String(describing: error?.localizedDescription))")
            }else if let object = objects{
                for items in object{
                    if let item = items as? PFObject{
                        
                        if let name = item["drinkName"] as? String{
                            self.drinkNames.append(name)
                        }else{
                            print("No Names Found")
                        }
                        
                        if let price = item["drinkPrice"] as? String{
                            self.drinkPrices.append(price)
                        }else{
                            print("No Prices Found")
                        }
                        
                        if let id = item.objectId{
                            self.esId.append(id)
                        }
                        
                        if let image = item["drinkImage"] as? PFFileObject{
                            self.drinkImages.append(image)
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
        mainTableView.delegate = self
        mainTableView.dataSource = self
        hamburgerMenuCons.constant = -250
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return drinkNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! milkTeasTableViewCell
        
        drinkImages[indexPath.row].getDataInBackground { (data, error) in
            if error != nil{
                print("Image Extraction Error: \(String(describing: error?.localizedDescription))")
            }else if let imageData = data{
                if let newImage = UIImage(data: imageData){
                    cell.drinkImage.image = newImage
                }
            }
        }
        
        cell.nameTitle.text = drinkNames[indexPath.row]
        cell.price.text = drinkPrices[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row: \(indexPath.row) \n Espresso Id: \(esId[indexPath.row])")
        UserDefaults.standard.setValue(esId[indexPath.row], forKey: "esId")
        performSegue(withIdentifier: "itemView", sender: nil)
        
    }
    
//MARK: Segues
    @IBAction func milkTeaPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
