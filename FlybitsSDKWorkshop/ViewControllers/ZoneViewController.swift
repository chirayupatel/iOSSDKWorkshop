//
//  ZoneViewController.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-09.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsSDK

class ZoneViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    struct Constants {
        static let DefaultTitle = "Zone"
        static let MomentSegue = "MomentSegue"
    }

    // MARK: - IBOutlets
    @IBOutlet var momentsCollectionView: UICollectionView!
    @IBOutlet var zoneImageView: UIImageView!

    // MARK: - Properties
    // Tutorial Section 3.5 (Selected Zone)

    // Tutorial Section 6.2 (Tags)

    // Tutorial Section 3.1 (Selected Zone)

    var tokens = [NSObjectProtocol]()

    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.

        // Tutorial Section 7.7 (Push Notifications)

        // Tutorial Section 7.8 (Push Notifications)

        // Tutorial Section 3.4 (Selected Zone)
        self.title = Constants.DefaultTitle

        // Tutorial Section 5.1 (Zone Connect / Disconnect - Analytics)

        // Tutorial Section 6.1 (Tags)
    }

    override func viewDidLayoutSubviews() {
        let flowLayout = momentsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        // Fit 3 on a screen at a time with a tiny amount of padding
        let size = floor(self.view.frame.width / 3) - 5
        let spacing = self.view.frame.width.truncatingRemainder(dividingBy: 3)
        flowLayout.itemSize = CGSize(width: size, height: size)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing + 5
        flowLayout.sectionInset = UIEdgeInsets(top: zoneImageView.frame.height + self.topLayoutGuide.length + 10, left: flowLayout.sectionInset.left, bottom: flowLayout.sectionInset.bottom, right: flowLayout.sectionInset.right)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tokens.forEach { NotificationCenter.default().removeObserver($0) }
        tokens.removeAll()
    }

    // MARK: - Helper Functions
    // Tutorial Section 6.3 (Tags)

    // Tutorial Section 6.4 (Tags)

    // Tutorial Section 7.9 (Push Notifications)

    // MARK: - Segue Functions
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Tutorial Section 4.3 (Moments)
    }

    // MARK: - UICollectionViewDataSource Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tutorial Section 3.6 (Selected Zone)
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MomentCollectionViewCell.Constants.CellReuseIdentifier, for: indexPath) as! MomentCollectionViewCell

        // Tutorial Section 3.7 (Selected Zone)

        return cell
    }

    // MARK: - UICollectionViewDelegate Functions
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Tutorial Section 4.2 (Moments)
        self.performSegue(withIdentifier: Constants.MomentSegue, sender: nil)
    }

    // MARK: - IBActions
    // Tutorial Section 6.5 (Tags)
}
