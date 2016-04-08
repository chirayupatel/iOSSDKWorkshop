//
//  MomentCollectionViewCell.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-10.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import UIKit

class MomentCollectionViewCell: UICollectionViewCell {
    struct Constants {
        static let CellReuseIdentifier = "MomentCollectionViewCell"
    }

    // MARK: - IBOutlets
    @IBOutlet var momentImageView: UIImageView!
}
