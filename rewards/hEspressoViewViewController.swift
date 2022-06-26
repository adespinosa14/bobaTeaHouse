//
//  hEspressoViewViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/6/20.
//

import UIKit
import Parse

class hEspressoViewViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var teaImage: UIImageView!
    @IBOutlet weak var sizePicker: UIPickerView!
    @IBOutlet weak var itemPrice: UILabel!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var quantityValue: UITextField!
    
    var sizePickerItems = ["One Size"]
    var numItemPrice = Double()
    var finalItemPrice = Double()
    var newTeaImage = UIImage()
    var teaSize = String()
    var teaName = String()
    
    override func viewDidAppear(_ animated: Bool) {
        
        let newID = UserDefaults.standard.object(forKey: "esId") as! String
        print(newID)
        
        let query = PFQuery(className: "handcraftedEspresso")
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
                                    self.teaName = originalTeaName
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
        
        finalItemPrice = 4.25
        teaSize = "One Size"
        
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
        
        if sizePickerItems[row] == "One Size"{
            numItemPrice = 4.25
            finalItemPrice = round(10000*(numItemPrice * Double(quantityValue.text!)!)) / 10000
            let newNumber = numberFormatter.string(from: NSNumber(value: finalItemPrice))!
            itemPrice.text = "\(newNumber)"
            teaSize = "One Size"
        }
    }
    
    @IBAction func quantityChanged(_ sender: Any) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
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
        
        saveItemInCart.sharedInstance.teaNameSave.append(teaName)
        saveItemInCart.sharedInstance.teaPriceSave.append(finalItemPrice)
        saveItemInCart.sharedInstance.teaImageSave.append(newTeaImage)
        saveItemInCart.sharedInstance.teaSizeSave.append(teaSize)
        saveItemInCart.sharedInstance.teaQuantitySave.append(Int(quantityValue.text!)!)
        
    }
    
}
