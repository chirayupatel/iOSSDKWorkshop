//
//  SpeedDialMoment.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

class SpeeddialMomentData {
    
    class SpeeddialData : NSObject {
        var name: String?
        var firstname: String?
        var lastname: String?
        var address: String?
        var email: String?
        var title: String?
        var summary: String?
        var type: String?
        var countryCode: String?
        var areaCode: String?
        var exchangeNumber: String?
        var lineNumber: String?
        var fullPhoneNumber: String?
        
        func getName() -> String? {
            return name ?? firstname ?? lastname ?? title
        }
        
        init?(dictionary: NSDictionary) {
            
            summary = dictionary.value(forKey: "description") as? String
            title = dictionary.value(forKey: "title") as? String
            name = dictionary.value(forKey: "name") as? String
            firstname = dictionary.value(forKey: "firstname") as? String
            lastname = dictionary.value(forKey: "lastname") as? String
            email = dictionary.value(forKey: "email") as? String
            address = dictionary.value(forKey: "address") as? String
            type = dictionary.value(forKey: "type") as? String
            countryCode = dictionary.value(forKey: "countryCode") as? String
            areaCode = dictionary.value(forKey: "areaCode") as? String
            exchangeNumber = dictionary.value(forKey: "exchangeNumber") as? String
            lineNumber = dictionary.value(forKey: "lineNumber") as? String
            fullPhoneNumber = dictionary.value(forKey: "fullPhoneNumber") as? String
        }
        
    }
    
    var phonenumbers:[SpeeddialData] = []
    
    init?(dictionary: NSDictionary) {
        let webs = dictionary.value(forKey: "phoneNumbers") as? [[String:AnyObject]]
        
        if let webs = webs {
            for data in webs {
                if let item = SpeeddialData(dictionary: data) {
                    phonenumbers.append(item)
                }
            }
        }
    }
}
