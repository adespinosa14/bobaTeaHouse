//
//  viewItemViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/2/20.
//

import UIKit
import Parse

class viewItemViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var sizePicker: UIPickerView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var quantityValue: UITextField!
    
    
    var sizePickerItems = ["16oz", "24oz", "Signature Bottle 24oz"]
    var stringItemPrice = String()
    var numItemPrice = Double()
    
    var finalItemPrice = Double()
    var finalItemSize = String()
    var teaObject = String()
    var teaName = String()
    var teaImage = UIImage()
    
    override func viewDidAppear(_ animated: Bool) {
        
        let newID = UserDefaults.standard.object(forKey: "itemID") as! String
        print(newID as! String)
        
        let query = PFQuery(className: "milkTeas")
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
                                
                                if let id = item.objectId as? String{
                                    self.teaObject = id
                                }
                                
                                if let teaPrice = item["truePrice"] as? Double{
                                    self.numItemPrice = teaPrice
                                    self.itemPrice.text = String("$\(teaPrice)")
                                    print("Tea Price Is: \(teaPrice)")
                                }
                                
                                if let teaName = item["fullTeaName"] as? String{
                                    self.itemName.text = teaName
                                }
                                
                                if let originalName = item["teaName"] as? String{
                                    self.teaName = originalName
                                }
                                
                                if let image = item["fileImage"] as? PFFileObject{
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
        
        print("LOADED")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        sizePicker.delegate = self
        sizePicker.dataSource = self
        quantityValue.text = String(1)
        finalItemSize = "16oz"
        finalItemPrice = 3.85
        
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
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale.current
        
        if sizePickerItems[row] == "16oz"{
            numItemPrice = 3.85
            finalItemPrice = Double(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)
            let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
            itemPrice.text = "\(newNumber)"
            finalItemSize = "16oz"
        }else if sizePickerItems[row] == "24oz"{
            numItemPrice = 4.6
            finalItemPrice = Double(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)
            let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
            itemPrice.text = "\(newNumber)"
            finalItemSize = "25oz"
        }else{
            numItemPrice = 5.60
            finalItemPrice = Double(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)
            let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
            itemPrice.text = "\(newNumber)"
            finalItemSize = "Signature Bottle 24oz"
        }
        
    }
    
    
    @IBAction func quantityChanged(_ sender: Any) {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale.current
        finalItemPrice = Double(round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000)
        let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
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
        alert.addAction(UIAlertAction(title: "Yay!", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print("Alert Dismissed")
        }))
        present(alert, animated: true, completion: nil)
        
        saveItemInCart.sharedInstance.teaImageSave.append(teaImage)
        saveItemInCart.sharedInstance.teaPriceSave.append(finalItemPrice)
        saveItemInCart.sharedInstance.teaSizeSave.append(finalItemSize)
        saveItemInCart.sharedInstance.teaNameSave.append(teaName)
        saveItemInCart.sharedInstance.teaQuantitySave.append(Int(quantityValue.text!)!)
        
        print("Final Price: \(finalItemPrice)")
        print("Final Size: \(finalItemSize)")
        
    }
    
}
