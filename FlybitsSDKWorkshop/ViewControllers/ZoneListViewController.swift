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

        flowLayout.itemSize = CGSize(width: self.view.frame.width, height: flowLayout.itemSize.height)
    }

    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Tutorial Section 3.3 (Selected Zone)
    }

    // MARK: - Functions

    // Tutorial Section 7.15 (Push Notifications)

    // MARK: - UICollectionViewDataSource Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tutorial Section 2.3 (Zones)
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZoneCollectionViewCell.Constants.CellReuseIdentifier, for: indexPath) as! ZoneCollectionViewCell

        // Tutorial Section 2.4 (Zones)

        return cell
    }

    // MARK: - UICollectionViewDelegate Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Tutorial Section 3.2 (Selected Zone)
        self.performSegue(withIdentifier: Constants.MomentSegue, sender: nil)
    }

    // MARK: - CoreLocationDataProviderDelegate Functions
    // Tutorial Section 8.3 (Context)
}

