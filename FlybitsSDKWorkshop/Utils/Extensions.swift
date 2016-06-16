//
//  Extensions.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

extension NSDictionary {
    func num(forKey key: String) -> NSNumber? {
        return self.value(forKey: key) as? NSNumber
    }

    func date(forKey key: String) -> Date {
        return Date(timeIntervalSince1970: num(forKey: key)?.doubleValue ?? 0)
    }
    
    func urlString(forKey key: String) -> String? {
        guard let url = self.value(forKey: key) as? String else { return nil }
        
        let loadableUrl: String
        // if its missing uri scheme, add http as the default otherwise webview doesn't load
        let range = url.range(of: "(.*)://", options: NSString.CompareOptions.regularExpressionSearch, range: nil, locale: nil)
        if range == nil || range!.isEmpty {
            loadableUrl = "http://" + url
        } else {
            loadableUrl = url
        }
        return loadableUrl
    }
}
