//
//  refreshingJuicesViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/1/20.
//

import UIKit
import Parse

class refreshingJuicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hamburgerMenuCons: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    var hamburgerConstant = 0
    
    var drinkNames = [String]()
    var drinkPrice = [String]()
    var juiceId = [String]()
    var drinkImage = [PFFileObject]()
    
    override func viewDidAppear(_ animated: Bool) {
        
        drinkNames.removeAll()
        drinkPrice.removeAll()
        drinkImage.removeAll()
        
        let query = PFQuery(className: "refreshingJuices")
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
                            self.drinkPrice.append(price)
                        }else{
                            print("No Prices Found")
                        }
                        
                        if let id = item.objectId{
                            self.juiceId.append(id)
                        }else{
                            print("No Id Found")
                        }
                        
                        if let image = item["drinkImage"] as? PFFileObject{
                            self.drinkImage.append(image)
                        }else{
                            print("No Image Found")
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
        hamburgerMenuCons.constant = -270
    }
    
    @IBAction func hamburgerPressed(_ sender: Any) {
        
        if hamburgerConstant == 0{
            hamburgerMenuCons.constant = 0
            hamburgerConstant = 1
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
        }else{
            hamburgerConstant = 0
            hamburgerMenuCons.constant = -270
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return drinkNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! milkTeasTableViewCell
        
        drinkImage[indexPath.row].getDataInBackground { (data, error) in
            if error != nil{
                print("Image Extraction Error: \(String(describing: error?.localizedDescription))")
            }else if let imageData = data{
                if let newImage = UIImage(data: imageData){
                    cell.drinkImage.image = newImage
                }
            }
        }
        
        cell.nameTitle.text = drinkNames[indexPath.row]
        cell.price.text = drinkPrice[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Table Row: \(indexPath.row) \n Juice Id: \(juiceId[indexPath.row])")
        UserDefaults.standard.setValue(juiceId[indexPath.row], forKey: "juiceId")
        performSegue(withIdentifier: "itemView", sender: nil)
    }
    
//MARK: Segues
    
    @IBAction func milkTeaPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
