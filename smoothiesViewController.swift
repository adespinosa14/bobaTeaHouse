//
//  slushiesViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/1/20.
//

import UIKit
import Parse

class smoothiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hamburgerCons: NSLayoutConstraint!
    @IBOutlet weak var mainTableView: UITableView!
    
    var hamburgerConstant = 0
    
    var drinkNames = [String]()
    var drinkPrice = [String]()
    var smoothieId = [String]()
    var drinkImage = [PFFileObject]()
    
    override func viewDidAppear(_ animated: Bool) {
        
        drinkNames.removeAll()
        drinkPrice.removeAll()
        drinkImage.removeAll()
        
        let query = PFQuery(className: "smoothies")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print("Parse Error: \(String(describing: error?.localizedDescription))")
            }else if let object = objects{
                for item in object{
                    if let items = item as? PFObject{
                        
                        if let name = items["drinkName"] as? String{
                            self.drinkNames.append(name)
                        }else{
                            print("No Names Found")
                        }
                        
                        if let price = items["drinkPrice"] as? String{
                            self.drinkPrice.append(price)
                        }else{
                            print("No Prices Found")
                        }
                        
                        if let id = items.objectId as? String{
                            self.smoothieId.append(id)
                        }else{
                            print("No Id Found")
                        }
                        
                        if let image = items["drinkImage"] as? PFFileObject{
                            self.drinkImage.append(image)
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
        hamburgerCons.constant = -250
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return drinkNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! milkTeasTableViewCell
        
        drinkImage[indexPath.row].getDataInBackground { (data, error) in
            if error != nil{
                print("Image Extraction Error")
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
    
    @IBAction func hamburgerMenu(_ sender: Any) {
        
        if hamburgerConstant == 0{
            
            hamburgerCons.constant = 0
            hamburgerConstant = 1
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
            
        }else{
            hamburgerCons.constant = -250
            hamburgerConstant = 0
            UIView.animate(withDuration: 0.75, animations: self.view.layoutIfNeeded)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Row Selected: \(indexPath.row) \n Object Id: \(smoothieId[indexPath.row])")
        UserDefaults.standard.setValue(smoothieId[indexPath.row], forKey: "smoothieId")
        performSegue(withIdentifier: "itemView", sender: nil)
    }
    
    //MARK: Segues
    @IBAction func milkTeasPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}
