//
//  TextMoment.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

// MARK: - Text Data
class TextMomentData {
    
    class TextData : NSObject {
        var id: Int = -1
        var title: String?
        var summary: String?
        
        init?(dictionary: NSDictionary) {
            id = (dictionary.valueForKey("id") as? NSNumber)?.integerValue ?? -1
            summary = dictionary.valueForKey("description") as? String
            title = dictionary.valueForKey("title") as? String
        }
        
    }
    
    var texts:[String:TextData] = [:]
    
    init?(dictionary: NSDictionary) {
        
        if let textsData = dictionary.valueForKey("texts") as? [[String:AnyObject]] {
            for itemDict in textsData {
                let id = (itemDict["id"] as? NSNumber)?.integerValue ?? -1
                if let locales = itemDict["locales"] as? [String:AnyObject] {
                    for (lang, data) in locales {
                        if let item = TextData(dictionary: data as! NSDictionary) {
                            item.id = id
                            texts[lang] = item
                        }
                    }
                }
            }
        }
    }
}