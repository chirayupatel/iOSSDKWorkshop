//
//  WebMoment.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

// Tutorial Section 4.6 (Moments) - Helper Classes
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
        var urlString: String?
        var locale: String!
        var url: URL? {
            get {
                if let urlString = urlString {
                    return URL(string: urlString)
                }
                return nil
            }
        }
        
        init?(dictionary: NSDictionary) {
            summary = dictionary.value(forKey: Constants.Description) as? String
            title = dictionary.value(forKey: Constants.Title) as? String
            urlString = dictionary.value(forKey: Constants.URL) as? String
        }
    }
    
    var websites:[WebData] = []
    
    init?(dictionary: NSDictionary) {
        for (locale, itemDict) in dictionary as! [String:AnyObject] {
            let webs = itemDict.value(forKey: Constants.Websites) as? [[String:AnyObject]]
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
