//
//  WebMoment.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

// Tutorial Section 4.6a (Moments) - Helper Classes
class WebMomentData {
    struct Constants {
        static let Websites = "websites"
    }
    
    class WebData : NSObject {
        struct Constants {
            static let Description = "description"
            static let Title = "title"
            static let URL = "url"
        }
        var title: String?
        var summary: String?
        var URLString: String?
        var locale: String!
        var URL: NSURL? {
            get {
                if let URLString = URLString {
                    return NSURL(string: URLString)
                }
                return nil
            }
        }
        
        init?(dictionary: NSDictionary) {
            summary = dictionary.valueForKey(Constants.Description) as? String
            title = dictionary.valueForKey(Constants.Title) as? String
            URLString = dictionary.valueForKey(Constants.URL) as? String
        }
    }
    
    var websites:[WebData] = []
    
    init?(dictionary: NSDictionary) {
        for (locale, itemDict) in dictionary as! [String:AnyObject] {
            let webs = itemDict.valueForKey(Constants.Websites) as? [[String:AnyObject]]
            if let webs = webs {
                for data in webs {
                    if let item = WebData(dictionary: data) {
                        item.locale = locale
                        websites.append(item)
                    }
                }
            }
        }
    }
}
