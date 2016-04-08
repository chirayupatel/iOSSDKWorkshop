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
            
            summary = dictionary.valueForKey("description") as? String
            title = dictionary.valueForKey("title") as? String
            name = dictionary.valueForKey("name") as? String
            firstname = dictionary.valueForKey("firstname") as? String
            lastname = dictionary.valueForKey("lastname") as? String
            email = dictionary.valueForKey("email") as? String
            address = dictionary.valueForKey("address") as? String
            type = dictionary.valueForKey("type") as? String
            countryCode = dictionary.valueForKey("countryCode") as? String
            areaCode = dictionary.valueForKey("areaCode") as? String
            exchangeNumber = dictionary.valueForKey("exchangeNumber") as? String
            lineNumber = dictionary.valueForKey("lineNumber") as? String
            fullPhoneNumber = dictionary.valueForKey("fullPhoneNumber") as? String
        }
        
    }
    
    var phonenumbers:[SpeeddialData] = []
    
    init?(dictionary: NSDictionary) {
        let webs = dictionary.valueForKey("phoneNumbers") as? [[String:AnyObject]]
        
        if let webs = webs {
            for data in webs {
                if let item = SpeeddialData(dictionary: data) {
                    phonenumbers.append(item)
                }
            }
        }
    }
}