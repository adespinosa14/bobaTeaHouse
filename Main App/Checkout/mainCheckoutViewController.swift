//
//  mainCheckoutViewController.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/9/20.
//

import UIKit
import Parse
import SquareInAppPaymentsSDK

var myNonce = String()

class mainCheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SQIPCardEntryViewControllerDelegate, PKPaymentAuthorizationViewControllerDelegate {
    
    @IBOutlet weak var itemTable: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    var checkoutPrice = Double()
    var i = 0
    var x = 0
    var priceSum = Double()
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTable.delegate = self
        itemTable.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        i = 0
        x = 0
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.locale = Locale.current
        while i < saveItemInCart.sharedInstance.teaPriceSave.count{
            checkoutPrice += saveItemInCart.sharedInstance.teaPriceSave[i] as! Double
            i += 1
        }
        priceSum = round(10000 * checkoutPrice) / 10000
        let newNumber = numberFormatter.string(from: NSNumber(value: priceSum))!
        checkoutButton.setTitle("Order: \(newNumber)", for: .normal)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return saveItemInCart.sharedInstance.teaNameSave.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! checkoutCell
        
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = Locale.current
        
        let cellName = saveItemInCart.sharedInstance.teaPriceSave[indexPath.row] as! Double
        let newNumber = numberFormatter.string(from: NSNumber(value: cellName))!
        cell.teaName.text = saveItemInCart.sharedInstance.teaNameSave[indexPath.row] as? String
        cell.teaPrice.text = String("\(newNumber)")
        cell.teaSize.text = String("Size: \(saveItemInCart.sharedInstance.teaSizeSave[indexPath.row]),")
        cell.teaImage.image = saveItemInCart.sharedInstance.teaImageSave[indexPath.row]
        cell.teaQuantity.text = String("Quantity: \(saveItemInCart.sharedInstance.teaQuantitySave[indexPath.row])")
        
        items.append(saveItemInCart.sharedInstance.teaNameSave[indexPath.row] as! String)
        
        return cell
    }
    
    @IBAction func orderButtonPressed(_ sender: Any) {
        payment()
        print("Begin Payment Process")
    }
    
//MARK: Create new Payment
    
    private func printCurlCommand(nonce : String) {
        let uuid = UUID().uuidString
        print("curl --request POST https://connect.squareup.com/v2/payments \\" +
            "--header \"Content-Type: application/json\" \\" +
            "--header \"Authorization: Bearer YOUR_ACCESS_TOKEN\" \\" +
            "--header \"Accept: application/json\" \\" +
            "--data \'{" +
            "\"idempotency_key\": \"\(uuid)\"," +
            "\"autocomplete\": true," +
            "\"amount_money\": {" +
            "\"amount\": 100," +
            "\"currency\": \"USD\"}," +
            "\"source_id\": \"\(myNonce)\"" +
            "}\'");
    }
    
    private var serverHostSet: Bool {
        return Constants.Square.CHARGE_SERVER_HOST != "REPLACE_ME"
    }
    
    func payment() {
        
        let theme = SQIPTheme()
        theme.errorColor = .red
        theme.tintColor = UIColor.blue
        theme.keyboardAppearance = .default
        theme.messageColor = UIColor.white
        theme.backgroundColor = UIColor.systemGreen
        theme.saveButtonTitle = "Order"
        theme.saveButtonTextColor = UIColor.white
        
        let cardEntry = SQIPCardEntryViewController(theme: theme)
        cardEntry.delegate = self
        cardEntry.collectPostalCode = true
        present(cardEntry, animated: true, completion: nil)
        
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
        
        print("Card Details: \(cardDetails.card)")
        print("Card Nonce: \(cardDetails.nonce)")
        
        myNonce = cardDetails.nonce
        
        guard serverHostSet else {
            printCurlCommand(nonce: cardDetails.nonce)
            completionHandler(nil)
            return
        }

        ChargeApi.processPayment(cardDetails.nonce) { (transactionID, errorDescription) in
            guard let errorDescription = errorDescription else {
                // No error occured, we successfully charged
                completionHandler(nil)
                return
            }

            // Pass error description
            let error = NSError(domain: "com.example.supercookie", code: 0, userInfo:[NSLocalizedDescriptionKey : errorDescription])
            completionHandler(error)
        }
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        
        dismiss(animated: true) {
            switch status {
            case .canceled:
                print("Payment Canceled")
                break
            case .success:
                guard self.serverHostSet else {
                    self.showCurlInformation()
                    return
                }

                self.didChargeSuccessfully()
            }
        }
        
    }
//MARK: If Sucessfull Or Error
    
    private func didNotChargeApplePay(_ error: String) {
        // Let user know that the charge was not successful
        let alert = UIAlertController(title: "Your order was not successful",
                                      message: error,
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func didChargeSuccessfully() {
        // Let user know that the charge was successful
        let alert = UIAlertController(title: "Your order was successful",
                                      message: "Go to your Square dashbord to see this order reflected in the sales tab.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showCurlInformation() {
        let alert = UIAlertController(title: "Nonce generated but not charged",
                                      message: "Check your console for a CURL command to charge the nonce, or replace Constants.Square.CHARGE_SERVER_HOST with your server host.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func showMerchantIdNotSet() {
        let alert = UIAlertController(title: "Missing Apple Pay Merchant ID",
                                      message: "To request an Apple Pay nonce, replace Constants.ApplePay.MERCHANT_IDENTIFIER with a Merchant ID.",
                                      preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
//MARK: Payment Proccessing
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        print("Hello There")
    }
}
