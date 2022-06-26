//
//  smoothieViewViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/6/20.
//

import UIKit
import Parse

class smoothieViewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var teaImage: UIImageView!
    @IBOutlet weak var sizePicker: UIPickerView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantityValue: UITextField!
    
    var sizePickerItems = ["16oz", "24oz"]
    var numItemPrice = Double()
    var numChange = Double()
    var finalItemPrice = Double()
    var newTeaImage = UIImage()
    var teaName = String()
    var teaSize = String()
    
    override func viewDidAppear(_ animated: Bool) {
        
        let newID = UserDefaults.standard.object(forKey: "smoothieId") as! String
        print(newID)
        
        let query = PFQuery(className: "smoothies")
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
                                    self.numChange = teaPrice
                                    self.itemPrice.text = String("$\(teaPrice)")
                                    
                                    if teaPrice == 4.25{
                                        self.finalItemPrice = 4.25
                                        self.teaSize = "16oz"
                                    }else if teaPrice == 4.5{
                                        self.finalItemPrice = 4.5
                                        self.itemPrice.text = "$4.50"
                                        self.teaSize = "16oz"
                                    }else if teaPrice == 4.75{
                                        self.finalItemPrice = 4.75
                                        self.teaSize = "16oz"
                                    }
                                    
                                }
                                
                                if let teaName = item["fullTeaName"] as? String{
                                    self.itemName.text = teaName
                                }
                                
                                if let originialTeaName = item["drinkName"] as? String{
                                    self.teaName = originialTeaName
                                }
                                
                                if let image = item["drinkImage"] as? PFFileObject{
                                    image.getDataInBackground { (data, error) in
                                        if error != nil{
                                            print("Image Extraction Error: \(String(describing: error))")
                                        }else if let imageData = data{
                                            if let newImage = UIImage(data: imageData){
                                                self.teaImage.image = newImage
                                                self.newTeaImage = newImage
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
        
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        switch numChange {
        case 4.25:
            if sizePickerItems[row] == "16oz"{
                numItemPrice = 4.25
                finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
                let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
                itemPrice.text = "\(newNumber)"
                teaSize = "16oz"
            }else if sizePickerItems[row] == "24oz"{
                numItemPrice = 5.25
                finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
                let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
                itemPrice.text = "\(newNumber)"
                teaSize = "24oz"
            }
            
        case 4.5:
            
            if sizePickerItems[row] == "16oz"{
                numItemPrice = 4.5
                finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
                let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
                itemPrice.text = "\(newNumber)"
                teaSize = "16oz"
            }else if sizePickerItems[row] == "24oz"{
                numItemPrice = 5.25
                finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
                let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
                itemPrice.text = "\(newNumber)"
                teaSize = "24oz"
            }
            
        case 4.75:
            
            if sizePickerItems[row] == "16oz"{
                numItemPrice = 4.75
                finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
                let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
                itemPrice.text = "\(newNumber)"
                teaSize = "16oz"
            }else if sizePickerItems[row] == "24oz"{
                numItemPrice = 5.5
                finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
                let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
                itemPrice.text = "\(newNumber)"
                teaSize = "24oz"
            }
            
        default:
            print("Error in The Pricing")
        }
        
    }
    
    @IBAction func quantityChange(_ sender: Any) {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
        let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
        itemPrice.text = "\(newNumber)"
    }
    
    @IBAction func viewPressed(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func orderPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Success", message: "Item Added To Cart", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yay!", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            print("Alert Dismissed")
        }))
        present(alert, animated: true, completion: nil)
        
        
        saveItemInCart.sharedInstance.teaImageSave.append(newTeaImage)
        saveItemInCart.sharedInstance.teaPriceSave.append(finalItemPrice)
        saveItemInCart.sharedInstance.teaNameSave.append(teaName)
        saveItemInCart.sharedInstance.teaQuantitySave.append(Int(quantityValue.text!)!)
        saveItemInCart.sharedInstance.teaSizeSave.append(teaSize)
        
    }
    
}
