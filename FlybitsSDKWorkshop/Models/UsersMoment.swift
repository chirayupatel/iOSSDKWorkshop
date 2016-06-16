//
//  UsersMoment.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation

public class UsersMomentData : NSObject {
    
    public var id : Int!
    public var displayBioOnMainView: Bool = false
    public var items: [DataItem] = []
    
    init?(dictionary:NSDictionary) {
        id = (dictionary.value(forKey: "id") as! NSNumber).intValue
        displayBioOnMainView = (dictionary.value(forKey: "id") as! NSNumber).boolValue ?? false
        if let itemArray = dictionary.value(forKey: "users") as? [NSDictionary] {
            for item in itemArray {
                if let item = DataItem(dictionary: item) {
                    items.append(item)
                }
            }
        }
    }
    
    public class DataItem {
        public var id : Int!
        public var imageUrl: String?
        public var backgroundImageUrl: String?
        public var localization: [String:ProfileItem] = [:]
        
        public func preferredLocalizedItem(_ locale:String?) -> ProfileItem? {
            if let locale = locale where localization[locale] != nil {
                return localization[locale]
            } else if let key = localization.first{
                return key.1
            }
            return nil
        }
        
        init?(dictionary:NSDictionary) {
            id = (dictionary.value(forKey: "id") as! NSNumber).intValue
            imageUrl = dictionary.value(forKey: "imageUrl") as? String
            backgroundImageUrl = dictionary.value(forKey: "backgroundImageUrl") as? String
            
            if let locales = dictionary.value(forKey: "locales") as? [String:AnyObject] {
                for (key, loc) in locales {
                    if let item = ProfileItem(dictionary: loc as! NSDictionary) {
                        
                        localization[key] = item
                    }
                }
            }
        }
    }
    
    //MARK - Item class
    public class ProfileItem {
        public var id : String!
        public var locale : String!
        public var firstName : String?
        public var lastName : String?
        public var position : String?
        public var branchTransitNumber : String?
        public var phoneNumber : String?
        public var email : String?
        public var aboutMe : String?
        public var facebookUrl : String?
        public var twitterUrl : String?
        public var spotifyUrl : String?
        public var iTunesUrl : String?
        public var googleMusicStoreUrl : String?
        public var instagramUrl : String?
        
        public var fullname : String {
            return (firstName ?? "") + " " + (lastName ?? "")
        }
        
        init?(dictionary:NSDictionary) {
            id = dictionary.value(forKey: "id") as! String
            locale = dictionary.value(forKey: "locale") as! String
            firstName = dictionary.value(forKey: "firstName") as? String
            lastName = dictionary.value(forKey: "lastName") as? String
            position = dictionary.value(forKey: "position") as? String
            branchTransitNumber = dictionary.value(forKey: "branchTransitNumber") as? String
            phoneNumber = dictionary.value(forKey: "phoneNumber") as? String
            email = dictionary.value(forKey: "email") as? String
            aboutMe = dictionary.value(forKey: "aboutMe") as? String
            facebookUrl = dictionary.urlString(forKey: "facebookUrl")
            twitterUrl = dictionary.urlString(forKey: "twitterUrl")
            spotifyUrl = dictionary.urlString(forKey: "spotifyUrl")
            iTunesUrl = dictionary.urlString(forKey: "iTunesUrl")
            googleMusicStoreUrl = dictionary.urlString(forKey: "googleMusicStoreUrl")
            instagramUrl = dictionary.urlString(forKey: "instagramUrl")
        }
    }
}
