//
//  PointOfInterestMoment.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-11.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import Foundation
import CoreLocation

class PointOfInterestMomentData {
    
    class LocationData : NSObject {
        var id: Int!
        var title: String?
        var summary: String?
        var displayPoint: Bool = false
        var displayPolygon: Bool = false
        var point: Point?
        var polygon: Polygon?
        
        
        var coordinate: CLLocationCoordinate2D? {
            
            if let point = point where displayPoint {
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(point.latitude), longitude: CLLocationDegrees(point.longitude))
            } else if let point = polygon?.centroid where displayPolygon {
                return CLLocationCoordinate2D(latitude: CLLocationDegrees(point.latitude), longitude: CLLocationDegrees(point.longitude))
            } else {
                return nil
            }
        }
        
        init?(dictionary: NSDictionary) {
            
            id = (dictionary.valueForKey("id") as? NSNumber)?.integerValue ?? -1
            title = dictionary.valueForKey("title") as? String
            summary = dictionary.valueForKey("description") as? String
            displayPoint = (dictionary.valueForKey("displayPoint") as? NSNumber)?.boolValue ?? false
            displayPolygon = (dictionary.valueForKey("displayPolygon") as? NSNumber)?.boolValue ?? false
            
            if let p = dictionary.valueForKey("point") as? NSDictionary, pp = Point(dictionary: p) {
                point = pp
            }
            
            if let poly = dictionary.valueForKey("polygon") as? NSDictionary, ppoly = Polygon(dictionary: poly) {
                polygon = ppoly
            }
        }
    }
    
    struct Point {
        var id : Int!
        var latitude: Float
        var longitude: Float
        var altitude: Float = 0.0
        
        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        }
        
        var valid: Bool {
            return abs(latitude) <= 90.0 && abs(longitude) <= 180.0
        }
        
        init?(dictionary:NSDictionary) {
            id = (dictionary.valueForKey("id") as? NSNumber)?.integerValue ?? -1
            latitude = (dictionary.valueForKey("latitude") as? NSNumber)?.floatValue ?? 128
            longitude = (dictionary.valueForKey("longitude") as? NSNumber)?.floatValue ?? 256
            altitude = (dictionary.valueForKey("altitude") as? NSNumber)?.floatValue ?? 0.0
        }
    }
    
    struct Polygon {
        var centroid: Point!
        var points: [Point] = []
        var id: Int!
        
        init?(dictionary:NSDictionary) {
            id = (dictionary.valueForKey("id") as? NSNumber)?.integerValue ?? -1
            
            if let centroidDict = dictionary.valueForKey("centroid") as? NSDictionary, c = Point(dictionary: centroidDict) {
                centroid = c
            }
            
            if let pointsArr = dictionary.valueForKey("points") as? [NSDictionary]{
                for x in pointsArr {
                    if let c = Point(dictionary: x) {
                        points.append(c)
                    }
                }
            }
        }
    }
    
    var locations:[String:LocationData] = [:]

    init?(dictionary: NSDictionary) {
        if let locales = dictionary as? [String:AnyObject] {
            for (locale, itemDictionary) in locales {
                if let locations = itemDictionary.valueForKey("locations") as? [NSDictionary] {
                    for x in locations {
                        if let item = LocationData(dictionary: x) {
                            self.locations[locale.uppercaseString] = item
                        }
                    }
                }
            }
        }
    }
}