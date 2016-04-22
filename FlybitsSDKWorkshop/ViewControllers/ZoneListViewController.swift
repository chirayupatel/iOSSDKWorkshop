//
//  ZoneListViewController.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-09.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsSDK

class ZoneListViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
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

        // Tutorial Section 7.12 (Push Notifications)

        // Tutorial Section 7.13 (Push Notifications)

        // Tutorial Section 7.14 (Push Notifications)

        // Tutorial Section 2.1 (Zones)
        let query = ZonesQuery()
        ZoneRequest.Query(query) { (zones, pagination, error) -> Void in
            guard error == nil else {
                print("Encountered error: \(error!)")
                return
            }
            self.zones = zones
            self.zonesCollectionView.reloadData()
        }.execute()
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

    // MARK: - UICollectionViewDataSource Functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tutorial Section 2.3 (Zones)
        return zones?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ZoneCollectionViewCell.Constants.CellReuseIdentifier, forIndexPath: indexPath) as! ZoneCollectionViewCell

        // Tutorial Section 2.4 (Zones)
        if let zone = zones?[indexPath.row] {
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
}

