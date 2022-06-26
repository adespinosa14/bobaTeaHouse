//
//  Constants.swift
//  rewards
//
//  Created by Andrew Espinosa on 12/16/20.
//

import Foundation

struct Constants {
    struct ApplePay {
        static let MERCHANT_IDENTIFIER: String = "REPLACE_ME"
        static let COUNTRY_CODE: String = "US"
        static let CURRENCY_CODE: String = "USD"
    }

    struct Square {
        static let SQUARE_LOCATION_ID: String = ""
        static let APPLICATION_ID: String  = "sandbox-sq0idb-t3uZw-38kc-wHRZSO_xv4Q"
        static let CHARGE_SERVER_HOST: String = "https://git.heroku.com/test-tea-house.git"
        static let CHARGE_URL: String = "\(CHARGE_SERVER_HOST)/chargeForCookie"
    }
}
