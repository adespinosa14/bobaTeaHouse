//
//  foodViewViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/6/20.
//

import UIKit
import Parse

class foodViewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var teaImage: UIImageView!
    @IBOutlet weak var sizePicker: UIPickerView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantityValue: UITextField!
    
    var sizePickerItems = ["16oz", "24oz", "Signature Bottle 24oz"]
    var numItemPrice = Double()
    
    override func viewDidAppear(_ animated: Bool) {
        
        let newID = UserDefaults.standard.object(forKey: "foodId") as! String
        print(newID)
        
        let query = PFQuery(className: "food")
        query.findObjectsInBackground { (objects, error) in
            if error != nil{
                print("Parse Error: \(String(describing: error))")
            }else{
                if let object = objects{
                    for items in object{
                        if let item = items as? PFObject{
                            if item.objectId! == newID{
                                if let teaID = item["objectID"] as? String{
                                    print(teaID)
                                }
                                
                                if let teaPrice = item["truePrice"] as? Double{
                                    self.numItemPrice = teaPrice
                                    self.itemPrice.text = String("$\(teaPrice)")
                                }
                                
                                if let teaName = item["fullMealName"] as? String{
                                    self.itemName.text = teaName
                                }
                                
                                if let image = item["mealImage"] as? PFFileObject{
                                    image.getDataInBackground { (data, error) in
                                        if error != nil{
                                            print("Image Extraction Error: \(String(describing: error))")
                                        }else if let imageData = data{
                                            if let newImage = UIImage(data: imageData){
                                                self.teaImage.image = newImage
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        print("LOADED")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sizePicker.delegate = self
        sizePicker.dataSource = self
        quantityValue.text = String(1)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sizePickerItems.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return sizePickerItems[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(sizePickerItems[row])
        
        switch numItemPrice {
        case 3:
            if sizePickerItems[row] == "16oz"{
                numItemPrice = 3.00
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }else if sizePickerItems[row] == "24oz"{
                numItemPrice = 3.75
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
                
            }else{
                numItemPrice = 4.75
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }
            
        case 3.75:
            
            if sizePickerItems[row] == "16oz"{
                numItemPrice = 3.75
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }else if sizePickerItems[row] == "24oz"{
                numItemPrice = 4.50
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
                
            }else{
                numItemPrice = 5.50
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }
            
        case 3.85:
            
            if sizePickerItems[row] == "16oz"{
                numItemPrice = 3.85
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }else if sizePickerItems[row] == "24oz"{
                numItemPrice = 4.50
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
                
            }else{
                numItemPrice = 5.50
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }
            
        case 4:
            
            if sizePickerItems[row] == "16oz"{
                numItemPrice = 4.00
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }else if sizePickerItems[row] == "24oz"{
                numItemPrice = 4.75
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
                
            }else{
                numItemPrice = 5.75
                itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
            }
            
        default:
            print("Error in The Pricing")
        }
        
    }
    
    
    @IBAction func quantityChanged(_ sender: Any) {
        itemPrice.text = "$\(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)"
    }
    
    @IBAction func viewPressed(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        
    }
    
}
