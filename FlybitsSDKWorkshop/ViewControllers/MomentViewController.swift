//
//  MomentViewController.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-10.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsSDK

class MomentViewController: UIViewController {
    struct Constants {
        static let DefaultTitle = "Moment"
        static let URL          = "url"
    }

    // MARK: - IBOutlets
    @IBOutlet var momentWebView: UIWebView!
    @IBOutlet var momentTextView: UITextView!

    // MARK: - Properties
    // Tutorial Section 4.1 (Moments)

    // MARK: - Functions
    // Tutorial Section 4.5 (Moments)

    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        // Tutorial Section 4.4 (Moments)
        self.title = Constants.DefaultTitle
    }
}
