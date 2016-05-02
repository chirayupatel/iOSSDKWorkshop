//
//  ZoneListViewController.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-09.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import UIKit
import CoreLocation
import FlybitsSDK

class ZoneListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, CoreLocationDataProviderDelegate {
    struct Constants {
        static let MomentSegue = "MomentSegue"
    }

    // MARK - IBOutlets
    @IBOutlet var zonesCollectionView: UICollectionView!

    // Tutorial Section 2.2 (Zones)
    var zones: [Zone]?

    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Tutorial Section 7.11 (Push Notifications)
        let zoneModifiedTopic = PushMessage.NotificationType(.Zone, action: .Modified)
        let _ = NSNotificationCenter.defaultCenter().addObserverForName(zoneModifiedTopic, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            self.updateZoneInfo(userInfo)
        }

        // Tutorial Section 7.12 (Push Notifications)
        let zoneEnteredTopic = PushMessage.NotificationType(.Zone, action: .Entered) // NOTE: This is for .Foreground Push
        let _ = NSNotificationCenter.defaultCenter().addObserverForName(zoneEnteredTopic, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            self.updateZoneInfo(userInfo)
        }

        // Tutorial Section 7.13 (Push Notifications)
        let zoneExitedTopic = PushMessage.NotificationType(.Zone, action: .Exited) // NOTE: This is for .Foreground Push
        let _ = NSNotificationCenter.defaultCenter().addObserverForName(zoneExitedTopic, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            self.updateZoneInfo(userInfo)
        }

        // Tutorial Section 7.14 (Push Notifications)
        let _ = NSNotificationCenter.defaultCenter().addObserverForName(PushManager.Constants.PushErrorTopic, object: nil, queue: nil) { (notification) in
            print(PushManager.Constants.PushErrorTopic)
            guard let error = notification.userInfo?[PushManager.Constants.PushErrorData] else {
                return // Unsure how to detect error
            }
            print("Encountered Push Error: \(error)")
        }

        // Tutorial Section 2.1 (Zones)
        let query = ZonesQuery()
        ZoneRequest.Query(query) { (zones, pagination, error) -> Void in
            guard error == nil else {
                print("Encountered error: \(error!)")
                return
            }

            // Tutorial Section 7.10 (Push Notifications)
            zones.forEach {
                $0.subscribeToPush()
                ZoneRequest.Favourite(zoneID: $0.id, favourite: true) { (zoneID, success, error) in
                    guard success else {
                        print("Unable to favourite Zone: \(zoneID)")
                        return
                    }
                }.execute()
            }

            self.zones = zones
            self.zonesCollectionView.reloadData()
        }.execute()

        // Tutorial Section 8.2 (Context)
        if let locationDataProvider = ContextManager.sharedManager.retrieveContextProvider(.CoreLocation) as? CoreLocationDataProvider {
            locationDataProvider.addDelegate(self)
        }
    }

    override func viewDidLayoutSubviews() {
        let flowLayout = zonesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        flowLayout.itemSize = CGSizeMake(self.view.frame.width, flowLayout.itemSize.height)
    }

    // MARK: - Segue Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Tutorial Section 3.3 (Selected Zone)
        if let zone = sender as? Zone {
            let zoneViewController = segue.destinationViewController as! ZoneViewController
            zoneViewController.selectedZone = zone
        }
    }

    // MARK: - Functions

    // Tutorial Section 7.15 (Push Notifications)
    /* User Info format:
     [
        "com.flybits.push.content"        : PushMessage // A PushMessage object
        "com.flybits.push.source"         : PushSource  // APNS or MQTT
        "com.flybits.push.sourceContent"  : APS Content // This is an optional entry that will contain the APS content of an APNS push message
        "com.flybits.push.fetchedContent" : A Flybits model object // i.e. a Zone or Moment

        -- OR --

        "com.flybits.push.error.type" : <Error Code>
     ]
     */
    func updateZoneInfo(userInfo: [NSObject: AnyObject]) {
        if let error = userInfo[PushManager.Constants.PushErrorType] {
            print("Encountered error: \(error)")
            return
        }
        guard let zone = userInfo[PushManager.Constants.PushFetchedContent] as? Zone else {
            print("No Zone fetched.")
            return
        }
        guard let index = zones?.indexOf(zone) else {
            // We don't have this Zone right now
            return
        }

        // Update the Zone and refresh the UI
        zones?[index] = zone

        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        dispatch_async(dispatch_get_main_queue()) {
            self.zonesCollectionView.reloadItemsAtIndexPaths([indexPath])
        }
    }

    // MARK: - UICollectionViewDataSource Functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tutorial Section 2.3 (Zones)
        return zones?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ZoneCollectionViewCell.Constants.CellReuseIdentifier, forIndexPath: indexPath) as! ZoneCollectionViewCell

        // Tutorial Section 2.4 (Zones)
        if let zone = zones?[indexPath.row] {
            // Tutorial Section 7.16 (Push Notifications)
            cell.isInZone = zone.insideZone

            cell.zoneNameLabel.text = zone.name.value
            cell.zoneDescriptionLabel.text = zone.zoneDescription.value
            zone.image.loadImage(._100, locale: nil) { (image, error) -> Void in
                guard error == nil else {
                    print("Encountered image loading error: \(error!)")
                    return
                }
                UIView.transitionWithView(cell.zoneImageView, duration: 0.2, options: .TransitionCrossDissolve, animations: { () -> Void in
                    cell.zoneImageView.image = image.loadedImage()
                    }, completion: nil)
            }
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate Functions
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Tutorial Section 3.2 (Selected Zone)
        if let zone = zones?[indexPath.item] {
            self.performSegueWithIdentifier(Constants.MomentSegue, sender: zone)
        }
    }

    // MARK: - CoreLocationDataProviderDelegate Functions
    func locationDataProvider(dataProvider: CoreLocationDataProvider, didUpdateLocations locations: [CLLocation]) {
        print("Location Updated: \(locations)")
    }

    // MARK: - CoreLocationDataProviderDelegate Functions
    // Tutorial Section 8.3 (Context)
}

