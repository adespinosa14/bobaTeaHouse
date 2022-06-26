//
//  flavoredTeaViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/1/20.
//

import UIKit
import Parse

class flavoredTeaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var hamburgerMenuCons: NSLayoutConstraint!
    @IBOutlet weak var hamburgerBackground: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var shopButton: UIBarButtonItem!
    
    
    var hamburgerConstant = 0
    var teaNames = [String]()
    var teaPrices = [String]()
    var teaImage = [PFFileObject]()
    var teaId = [String]()
    
    override func viewDidAppear(_ animated: Bool) {
        
        teaNames.removeAll()
        teaPrices.removeAll()
        teaImage.removeAll()
        
        let query = PFQuery(className: "flavoredTea")
        query.findObjectsInBackground { (objects, error) in
            
            if error != nil{
                print("Parse Error: \(String(describing: error?.localizedDescription))")
            }else if let object = objects{
                for items in object{
                    if let newTea = items as? PFObject{
                        if let teaName = newTea["teaName"] as? String{
                            self.teaNames.append(teaName)
                        }else{
                            print("No Tea Name Found")
                        }
                        
                        if let teaPrice = newTea["price"] as? String{
                            self.teaPrices.append(teaPrice)
                        }else{
                            print("No Tea Price Found")
                        }
                        
                        if let id = newTea.objectId as? String{
                            self.teaId.append(id)
                        }else{
                            print("No Tea Id Found")
                        }
                        
                        if let teaImage = newTea["teaImage"] as? PFFileObject{
                            self.teaImage.append(teaImage)
                        }else{
                            print("No Tea Image Found")
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teaPrices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! milkTeasTableViewCell
        
        teaImage[indexPath.row].getDataInBackground { (data, error) in
            if error != nil{
                print("Image Extraction Error: \(String(describing: error?.localizedDescription))")
            }else{
                if let imageData = data{
                    if let image = UIImage(data: imageData){
                        cell.drinkImage.image = image
                    }
                }
            }
        }
        cell.nameTitle.text = teaNames[indexPath.row]
        cell.price.text = teaPrices[indexPath.row]
        
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
        
        print("Row Pressed: \(indexPath.row) \n Object ID: \(teaId[indexPath.row])")
        
        UserDefaults.standard.setValue(teaId[indexPath.row], forKey: "fTeaId")
        
        performSegue(withIdentifier: "itemView", sender: nil)
        
    }
    
//MARK: Segues
    
    @IBAction func milkTeaPressed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
}
