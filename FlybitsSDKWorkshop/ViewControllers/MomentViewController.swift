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
    var moment: Moment! {
        didSet {
            self.title = moment.name.value ?? Constants.DefaultTitle
        }
    }

    // MARK: - Functions
    // Tutorial Section 4.5 (Moments)
    func loadMomentData() {
        let urlString: String
        if moment.packageName == "com.flybits.moments.text" {
            urlString = "\(moment.launchURL)/TextBits"
        } else if moment.packageName == "com.flybits.moments.website" {
            urlString = "\(moment.launchURL)/WebsiteBits?alllocales=true"
        } else if moment.packageName == "com.flybits.moments.jsonbuilder" {
            urlString = "\(moment.launchURL)/KeyValuePairs/AsMetadata"
        } else {
            urlString = ""
        }
        
        let request = URLRequest(url: URL(string: urlString)!)
        let task = URLSession.shared().dataTask(with: request) { (data, response, error) -> Void in
            guard let data = data else {
                return
            }
            if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String:AnyObject] where json != nil {
                
                // Accessing metadata in Swift:
                // moment.metadata ...
                
                if self.moment.packageName == "com.flybits.moments.text" {
                    self.momentWebView.isHidden = true
                    self.momentTextView.isHidden = false
                    let textMomentData = TextMomentData(dictionary: json!)!
                    DispatchQueue.main.async { () -> Void in
                        self.momentTextView.text = textMomentData.texts["en"]?.summary ?? "No data."
                    }
                } else if self.moment.packageName == "com.flybits.moments.website" {
                    self.momentWebView.isHidden = false
                    self.momentTextView.isHidden = true
                    let webMomentData = WebMomentData(dictionary: json!)!
                    if let websiteURL = webMomentData.websites.first?.url {
                        let webRequest = URLRequest(url: websiteURL)
                        self.momentWebView.loadRequest(webRequest)
                    }
                } else if self.moment.packageName == "com.flybits.moments.jsonbuilder" {
                    self.momentWebView.isHidden = true
                    self.momentTextView.isHidden = false
                    DispatchQueue.main.async { () -> Void in
                        self.momentTextView.text = json!.debugDescription
                    }
                }
            }
        }
        task.resume()
    }

    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        // Tutorial Section 4.4 (Moments)
        if let moment = moment {
            self.title = moment.name.value ?? Constants.DefaultTitle
            
            _ = MomentRequest.autoValidate(moment: moment) { (validated, error) -> Void in
                if validated {
                    self.loadMomentData()
                } else {
                    print("Encountered validation error: \(error)")
                }
            }.execute()
        } else {
            self.title = Constants.DefaultTitle
        }
    }
}
