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
            
            id = (dictionary.value(forKey: "id") as? NSNumber)?.intValue ?? -1
            title = dictionary.value(forKey: "title") as? String
            summary = dictionary.value(forKey: "description") as? String
            displayPoint = (dictionary.value(forKey: "displayPoint") as? NSNumber)?.boolValue ?? false
            displayPolygon = (dictionary.value(forKey: "displayPolygon") as? NSNumber)?.boolValue ?? false
            
            if let p = dictionary.value(forKey: "point") as? NSDictionary, pp = Point(dictionary: p) {
                point = pp
            }
            
            if let poly = dictionary.value(forKey: "polygon") as? NSDictionary, ppoly = Polygon(dictionary: poly) {
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
            id = (dictionary.value(forKey: "id") as? NSNumber)?.intValue ?? -1
            latitude = (dictionary.value(forKey: "latitude") as? NSNumber)?.floatValue ?? 128
            longitude = (dictionary.value(forKey: "longitude") as? NSNumber)?.floatValue ?? 256
            altitude = (dictionary.value(forKey: "altitude") as? NSNumber)?.floatValue ?? 0.0
        }
    }
    
    struct Polygon {
        var centroid: Point!
        var points: [Point] = []
        var id: Int!
        
        init?(dictionary:NSDictionary) {
            id = (dictionary.value(forKey: "id") as? NSNumber)?.intValue ?? -1
            
            if let centroidDict = dictionary.value(forKey: "centroid") as? NSDictionary, c = Point(dictionary: centroidDict) {
                centroid = c
            }
            
            if let pointsArr = dictionary.value(forKey: "points") as? [NSDictionary]{
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
                if let locations = itemDictionary.value(forKey: "locations") as? [NSDictionary] {
                    for x in locations {
                        if let item = LocationData(dictionary: x) {
                            self.locations[locale.uppercased()] = item
                        }
                    }
                }
            }
        }
    }
}
