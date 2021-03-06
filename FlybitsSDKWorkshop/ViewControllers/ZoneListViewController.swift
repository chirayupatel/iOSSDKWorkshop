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

    var observerTokens = [NSObjectProtocol]()

    // Tutorial Section 2.2 (Zones)

    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Tutorial Section 7.11 (Push Notifications)

        // Tutorial Section 7.12 (Push Notifications)

        // Tutorial Section 7.13 (Push Notifications)

        // Tutorial Section 7.14 (Push Notifications)

        // Tutorial Section 2.1 (Zones)

        // Tutorial Section 8.2 (Context)
    }

    override func viewDidLayoutSubviews() {
        let flowLayout = zonesCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        flowLayout.itemSize = CGSizeMake(self.view.frame.width, flowLayout.itemSize.height)
    }

    // MARK: - Segue Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Tutorial Section 3.3 (Selected Zone)

        // Cleanup tokens (if any)
        for token in observerTokens {
            NSNotificationCenter.defaultCenter().removeObserver(token)
        }
        observerTokens.removeAll()
    }

    // MARK: - Functions

    // Tutorial Section 7.15 (Push Notifications)

    // MARK: - UICollectionViewDataSource Functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tutorial Section 2.3 (Zones)
        return 5
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ZoneCollectionViewCell.Constants.CellReuseIdentifier, forIndexPath: indexPath) as! ZoneCollectionViewCell

        // Tutorial Section 2.4 (Zones)

        return cell
    }

    // MARK: - UICollectionViewDelegate Functions
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Tutorial Section 3.2 (Selected Zone)
        self.performSegueWithIdentifier(Constants.MomentSegue, sender: nil)
    }

    // MARK: - CoreLocationDataProviderDelegate Functions
    // Tutorial Section 8.3 (Context)
}
