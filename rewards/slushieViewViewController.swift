//
//  slushieViewViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/6/20.
//

import UIKit
import Parse

class slushieViewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sizePicker: UIPickerView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantityValue: UITextField!
    
    var sizePickerItems = ["16oz", "24oz"]
    var numItemPrice = Double()
    var totalItemPrice = Double()
    var originialTeaName = String()
    var teaSize = String()
    var teaImage = UIImage()
    
    override func viewDidAppear(_ animated: Bool) {
        
        let newID = UserDefaults.standard.object(forKey: "slushieId") as! String
        print(newID as! String)
        
        let query = PFQuery(className: "slushies")
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
                                
                                if let teaName = item["fullTeaName"] as? String{
                                    self.itemName.text = teaName
                                }
                                
                                if let originalTeaName = item["drinkName"] as? String{
                                    self.originialTeaName = originalTeaName
                                }
                                
                                if let image = item["drinkImage"] as? PFFileObject{
                                    image.getDataInBackground { (data, error) in
                                        if error != nil{
                                            print("Image Extraction Error: \(String(describing: error))")
                                        }else if let imageData = data{
                                            if let newImage = UIImage(data: imageData){
                                                self.itemImage.image = newImage
                                                self.teaImage = newImage
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
        
        totalItemPrice =  4.35
        teaSize = "16oz"
        
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
        
        if sizePickerItems[row] == "16oz"{
            numItemPrice = 4.35
            totalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
            let newNumber = numberFormatter.string(from: NSNumber(value: totalItemPrice))!
            itemPrice.text = "\(newNumber)"
            teaSize = "16oz"
        }else if sizePickerItems[row] == "24oz"{
            numItemPrice = 5.10
            totalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
            let newNumber = numberFormatter.string(from: NSNumber(value: totalItemPrice))!
            itemPrice.text = "\(newNumber)"
            teaSize = "24oz"
        }
    }
    
    @IBAction func quantityChange(_ sender: Any) {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        totalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
        let newNumber = numberFormatter.string(from: NSNumber(value: totalItemPrice))!
        itemPrice.text = "\(newNumber)"
    }
    
    @IBAction func viewPressed(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func order(_ sender: Any) {
        
        let alert = UIAlertController(title: "Success", message: "Item Added To Cart", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Yay!", style: .default, handler: { (UIAlertAction) in
            alert.dismiss(animated: true, completion: nil)
            print("Alert Dismissed")
        }))
        present(alert, animated: true, completion: nil)
        
        saveItemInCart.sharedInstance.teaNameSave.append(originialTeaName)
        saveItemInCart.sharedInstance.teaPriceSave.append(totalItemPrice)
        saveItemInCart.sharedInstance.teaImageSave.append(teaImage)
        saveItemInCart.sharedInstance.teaSizeSave.append(teaSize)
        saveItemInCart.sharedInstance.teaQuantitySave.append(Int(quantityValue.text!)!)
    }
    
}
