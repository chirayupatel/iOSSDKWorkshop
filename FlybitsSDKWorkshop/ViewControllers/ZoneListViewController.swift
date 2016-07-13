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

    var observerTokens = [NSObjectProtocol]()

    // Tutorial Section 2.2 (Zones)
    var zones: [Zone]?

    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Tutorial Section 7.11 (Push Notifications)
        let zoneModifiedTopic = PushMessage.NotificationType(.zone, action: .modified)
        let zoneModifiedToken = NotificationCenter.default().addObserver(forName: zoneModifiedTopic, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            self.updateZoneInfo(userInfo)
        }
        observerTokens.append(zoneModifiedToken)

        // Tutorial Section 7.12 (Push Notifications)
        let zoneEnteredTopic = PushMessage.NotificationType(.zone, action: .entered) // NOTE: This is for .Foreground Push
        let zoneEnteredToken = NotificationCenter.default().addObserver(forName: zoneEnteredTopic, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            self.updateZoneInfo(userInfo)
        }
        observerTokens.append(zoneEnteredToken)

        // Tutorial Section 7.13 (Push Notifications)
        let zoneExitedTopic = PushMessage.NotificationType(.zone, action: .exited) // NOTE: This is for .Foreground Push
        let zoneExitedToken = NotificationCenter.default().addObserver(forName: zoneExitedTopic, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            self.updateZoneInfo(userInfo)
        }
        observerTokens.append(zoneExitedToken)

        // Tutorial Section 7.14 (Push Notifications)
        let _ = NotificationCenter.default().addObserver(forName: PushManager.Constants.PushErrorTopic, object: nil, queue: nil) { (notification) in
            print(PushManager.Constants.PushErrorTopic)
            guard let error = notification.userInfo?[PushManager.Constants.PushErrorData] else {
                return // Unsure how to detect error
            }
            print("Encountered Push Error: \(error)")
        }

        let zoneEnteredAPNSTopic = PushMessage.NotificationType(.momentInstance, action: .zoneEntered)
        let zoneEnteredAPNSToken = NotificationCenter.default().addObserver(forName: zoneEnteredAPNSTopic, object: nil, queue: nil) { (notification) in
            guard let userInfo = notification.userInfo else {
                return
            }
            self.updateZoneInfo(userInfo)
        }
        observerTokens.append(zoneEnteredAPNSToken)

        // Tutorial Section 2.1 (Zones)
        let query = ZonesQuery()
        _ = ZoneRequest.query(query) { (zones, pagination, error) -> Void in
            guard error == nil else {
                print("Encountered error: \(error!)")
                return
            }

            // Tutorial Section 7.10 (Push Notifications)
            zones.forEach {
                $0.subscribeToPush()
                _ = ZoneRequest.favourite(identifier: $0.identifier, favourite: true) { (zoneID, success, error) in
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
        if let locationDataProvider = ContextManager.sharedManager.retrieve(.coreLocation) as? CoreLocationDataProvider {
            _ = locationDataProvider.addDelegate(self)
        }
    }

    override func viewDidLayoutSubviews() {
        let flowLayout = zonesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        flowLayout.itemSize = CGSize(width: self.view.frame.width, height: flowLayout.itemSize.height)
    }

    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Tutorial Section 3.3 (Selected Zone)
        if let zone = sender as? Zone {
            let zoneViewController = segue.destinationViewController as! ZoneViewController
            zoneViewController.selectedZone = zone
        }

        // Cleanup tokens (if any)
        for token in observerTokens {
            NotificationCenter.default().removeObserver(token)
        }
        observerTokens.removeAll()
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
    func updateZoneInfo(_ userInfo: [String: Any]) {
        if let error = userInfo[PushManager.Constants.PushErrorType] {
            print("Encountered error: \(error)")
            return
        }
        guard let zone = userInfo[PushManager.Constants.PushFetchedContent] as? Zone else {
            print("No Zone fetched.")
            return
        }
        guard let index = zones?.index(of: zone) else {
            // We don't have this Zone right now
            return
        }

        // Update the Zone and refresh the UI
        zones?[index] = zone

        let indexPath = IndexPath(item: index, section: 0)
        DispatchQueue.main.async {
            self.zonesCollectionView.reloadItems(at: [indexPath])
        }
    }

    // MARK: - UICollectionViewDataSource Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tutorial Section 2.3 (Zones)
        return zones?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZoneCollectionViewCell.Constants.CellReuseIdentifier, for: indexPath) as! ZoneCollectionViewCell

        // Tutorial Section 2.4 (Zones)
        if let zone = zones?[indexPath.row] {
            // Tutorial Section 7.16 (Push Notifications)
            cell.isInZone = zone.insideZone

            cell.zoneNameLabel.text = zone.name.value
            cell.zoneDescriptionLabel.text = zone.zoneDescription.value
            _ = zone.image.loadImage(forSize: ._100) { (image, error) -> Void in
                guard error == nil else {
                    print("Encountered image loading error: \(error!)")
                    return
                }
                UIView.transition(with: cell.zoneImageView, duration: 0.2, options: .transitionCrossDissolve, animations: { () -> Void in
                    cell.zoneImageView.image = image.loadedImage()
                    }, completion: nil)
            }
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Tutorial Section 3.2 (Selected Zone)
        if let zone = zones?[indexPath.item!] {
            self.performSegue(withIdentifier: Constants.MomentSegue, sender: zone)
        }
    }

    // MARK: - CoreLocationDataProviderDelegate Functions
    // Tutorial Section 8.3 (Context)
    func locationDataProvider(_ dataProvider: CoreLocationDataProvider, didUpdateLocations locations: [CLLocation]) {
        print("Location Updated: \(locations)")
    }
}
