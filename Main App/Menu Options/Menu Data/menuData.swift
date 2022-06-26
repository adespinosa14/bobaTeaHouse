//
//  menuData.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/2/20.
//

import Foundation
import UIKit

class cartItems{
    
    struct newItemForDrinks {
        
        var size = String()
        var price = Double()
        var quantity = Int()
        
        init(drinkSize size: String, drinkPrice price: Double, drinkQuantity quantity: Int) {
            self.size = size
            self.price = price
            self.quantity = quantity
        }
        
    }
    
}

class saveItemInCart{
    
    var teaNameSave = [Any]()
    var teaPriceSave = [Any]()
    var teaSizeSave = [Any]()
    var teaImageSave = [UIImage]()
    var teaQuantitySave = [Int]()
    
    class var sharedInstance: saveItemInCart{
        struct singleton{
            static var instance = saveItemInCart()
        }
        return singleton.instance
    }
    
    init() {
        
        switch UserDefaults.standard.object(forKey: "teaNameSaves") == nil && UserDefaults.standard.object(forKey: "teaPriceSaves") == nil && UserDefaults.standard.object(forKey: "teaSizeSaves") == nil && UserDefaults.standard.object(forKey: "teaObjectSaves") == nil && UserDefaults.standard.object(forKey: "teaQuantitySaves") == nil{
        case true:
            print("No Item In Cart")
        default:
            teaNameSave = UserDefaults.standard.object(forKey: "teaNameSaves") as! Array
            teaNameSave = UserDefaults.standard.object(forKey: "teaPriceSaves") as! Array
            teaPriceSave = UserDefaults.standard.object(forKey: "teaSizeSaves") as! Array
            teaImageSave = UserDefaults.standard.object(forKey: "teaImageSaves") as! Array
            teaQuantitySave = UserDefaults.standard.object(forKey: "teaQuantitySaves") as! Array
        }
    }
}
