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
        id = (dictionary.valueForKey("id") as! NSNumber).integerValue
        displayBioOnMainView = (dictionary.valueForKey("id") as! NSNumber).boolValue ?? false
        if let itemArray = dictionary.valueForKey("users") as? [NSDictionary] {
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
        
        public func preferredLocalizedItem(locale:String?) -> ProfileItem? {
            if let locale = locale where localization[locale] != nil {
                return localization[locale]
            } else if let key = localization.first{
                return key.1
            }
            return nil
        }
        
        init?(dictionary:NSDictionary) {
            id = (dictionary.valueForKey("id") as! NSNumber).integerValue
            imageUrl = dictionary.valueForKey("imageUrl") as? String
            backgroundImageUrl = dictionary.valueForKey("backgroundImageUrl") as? String
            
            if let locales = dictionary.valueForKey("locales") as? [String:AnyObject] {
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
            id = dictionary.valueForKey("id") as! String
            locale = dictionary.valueForKey("locale") as! String
            firstName = dictionary.valueForKey("firstName") as? String
            lastName = dictionary.valueForKey("lastName") as? String
            position = dictionary.valueForKey("position") as? String
            branchTransitNumber = dictionary.valueForKey("branchTransitNumber") as? String
            phoneNumber = dictionary.valueForKey("phoneNumber") as? String
            email = dictionary.valueForKey("email") as? String
            aboutMe = dictionary.valueForKey("aboutMe") as? String
            facebookUrl = dictionary.urlStringForKey("facebookUrl")
            twitterUrl = dictionary.urlStringForKey("twitterUrl")
            spotifyUrl = dictionary.urlStringForKey("spotifyUrl")
            iTunesUrl = dictionary.urlStringForKey("iTunesUrl")
            googleMusicStoreUrl = dictionary.urlStringForKey("googleMusicStoreUrl")
            instagramUrl = dictionary.urlStringForKey("instagramUrl")
        }
    }
}