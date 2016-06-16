//
//  YoutubeMoment.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

public class YoutubeMomentData {
    public var items: [VideoItem] = []
    
    init?(dictionary:NSDictionary) {
        let dict = dictionary as! [String:NSDictionary]
        print(dict)
        for (locale, itemDict) in dict {
            print(locale)
            
            if let videosDict = itemDict.value(forKey: "youtubeVideos") as? [NSDictionary] {
                for tempDict in videosDict {
                    
                    if let item = VideoItem(dictionary: tempDict, localizationCode: locale) {
                        items.append(item)
                    }
                }
            }
            
        }
    }
    
    public class VideoItem {
        public var localizationCode: String!
        public var videoUrl: String?
        public var videoID: String?
        public var embeddedUrl: String?
        public var channelTitle: String?
        public var videoDescription: String?
        public var videoTitle: String?
        public var thumbnail: Thumbnail!
        
        init?(dictionary:NSDictionary, localizationCode:String) {
            
            let tempDict = dictionary
            self.localizationCode = localizationCode
            videoUrl = tempDict.value(forKey: "videoUrl") as? String
            embeddedUrl = tempDict.value(forKey: "embeddedUrl") as? String
            
            if let videoDict = tempDict.value(forKey: "video") as? [String:AnyObject] {
                videoID = videoDict["id"] as? String
                if let snippet = videoDict["snippet"] as? [String:AnyObject] {
                    channelTitle = snippet["channelTitle"] as? String
                    videoDescription = snippet["description"] as? String
                    videoTitle = snippet["title"] as? String
                    
                    if let thumbnails = snippet["thumbnails"] as? [String:AnyObject] {
                        thumbnail = Thumbnail(dictionary: thumbnails["default"] as! NSDictionary)
                    }
                }
            }
        }
    }
    
    public struct Thumbnail {
        var height: Int
        var width: Int
        var url: String
        
        init(dictionary:NSDictionary) {
            height = dictionary.num(forKey: "height")!.intValue
            width = dictionary.num(forKey: "width")!.intValue
            url = dictionary.value(forKey: "url") as! String
        }
    }
}
