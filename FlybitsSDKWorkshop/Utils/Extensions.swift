//
//  Extensions.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

extension NSDictionary {
    func numForKey(key:String) -> NSNumber? {
        return self.valueForKey(key) as? NSNumber
    }

    func dateForKey(key:String) -> NSDate {
        return NSDate(timeIntervalSince1970: numForKey(key)?.doubleValue ?? 0)
    }
    
    func urlStringForKey(key:String) -> String? {
        guard let url = self.valueForKey(key) as? String else { return nil }
        
        let loadableUrl:String
        // if its missing uri scheme, add http as the default otherwise webview doesn't load
        if url.rangeOfString("(.*)://", options: NSStringCompareOptions.RegularExpressionSearch, range: nil, locale: nil)?.count ?? 0 == 0 {
            loadableUrl = "http://" + url
        } else {
            loadableUrl = url
        }
        return loadableUrl
    }
}