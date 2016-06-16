//
//  ZoneCollectionViewCell.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-09.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import UIKit

class ZoneCollectionViewCell: UICollectionViewCell {
    struct Constants {
        static let CellReuseIdentifier = "ZoneCollectionViewCell"
    }

    // MARK: - IBOutlets
    @IBOutlet var zoneImageView: UIImageView!
    @IBOutlet var zoneNameLabel: UILabel!
    @IBOutlet var zoneDescriptionLabel: UILabel!
    @IBOutlet var insideZoneIcon: UIView!

    // MARK: - Properties
    var isInZone: Bool = false {
        didSet {
            insideZoneIcon?.backgroundColor = isInZone ? UIColor.green() : UIColor.darkGray()
        }
    }

    // MARK: - Cell Lifecycle Functions
    override func prepareForReuse() {
        zoneNameLabel.text = ""
        zoneDescriptionLabel.text = ""
        isInZone = false
    }
}
