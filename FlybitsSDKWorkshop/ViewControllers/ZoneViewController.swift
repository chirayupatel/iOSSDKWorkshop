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
    var moments: [Moment]?

    // Tutorial Section 6.2 (Tags)
    var tags: [VisibleTag]?
    var selectedTagFilter: [String]? // A list of Zone Moment Instance IDs

    // Tutorial Section 3.1 (Selected Zone)
    var selectedZone: Zone! {
        didSet {
            self.title = selectedZone?.name.value ?? Constants.DefaultTitle
        }
    }

    var tokens = [NSObjectProtocol]()

    // MARK: - View Lifecycle Functions
    override func viewDidLoad() {
        // Do any additional setup after loading the view, typically from a nib.

        // Tutorial Section 7.7 (Push Notifications)
        let enteredTopic = PushMessage.CompleteNotificationType(selectedZone, action: .Entered)
        let enteredToken = NSNotificationCenter.defaultCenter().addObserverForName(enteredTopic, object: nil, queue: nil) { (notification) in
            self.zoneEnteredMessage(notification.userInfo)
        }
        tokens.append(enteredToken)

        // Tutorial Section 7.8 (Push Notifications)
        let zoneEnteredTopic = PushMessage.CompleteNotificationType(.MomentInstance, action: .ZoneEntered, rawAction: selectedZone.id)
        let zoneEnteredToken = NSNotificationCenter.defaultCenter().addObserverForName(zoneEnteredTopic, object: nil, queue: nil) { (notification) in
            self.zoneEnteredMessage(notification.userInfo)
        }
        tokens.append(zoneEnteredToken)

        // Tutorial Section 3.4 (Selected Zone)
        if let selectedZone = selectedZone {
            self.title = selectedZone.name.value ?? Constants.DefaultTitle
            self.zoneImageView.image = selectedZone.image.loadedImage()
            
            MomentRequest.GetZoneMoments(zoneID: selectedZone.id) { (moments, pagination, error) -> Void in
                guard error == nil else {
                    print("Encountered error: \(error!)")
                    return
                }
                self.moments = moments
                self.momentsCollectionView.reloadData()
            }.execute()
        } else {
            self.title = Constants.DefaultTitle
        }

        // Tutorial Section 5.1 (Zone Connect / Disconnect - Analytics)
        let query = DeviceQuery(type: DeviceQuery.EntityType.Zone, id: selectedZone.id)
        DeviceRequest.Connect(query) { (error) -> Void in
            // Check for success
            guard error == nil else {
                print("Encountered error connecting to Zone: \(self.selectedZone.id)")
                return
            }
            
            DeviceRequest.Disconnect(query) { (error) -> Void in
                // Check for success
                guard error == nil else {
                    print("Encountered error connecting to Zone: \(self.selectedZone.id)")
                    return
                }
            }.execute()
        }.execute()

        // Tutorial Section 6.1 (Tags)
        TagsRequest.Query(TagQuery()) { (tags: [VisibleTag]?, pagination, error) -> Void in
            guard error == nil else {
                print("Encountered error retrieving tags: \(error!)")
                return
            }
            self.tags = tags
            self.toggleFilterButtonDisplay(tags == nil)
        }.execute()
    }

    override func viewDidLayoutSubviews() {
        let flowLayout = momentsCollectionView.collectionViewLayout as! UICollectionViewFlowLayout

        // Fit 3 on a screen at a time with a tiny amount of padding
        let size = floor(self.view.frame.width / 3) - 5
        let spacing = self.view.frame.width % 3
        flowLayout.itemSize = CGSizeMake(size, size)
        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.minimumLineSpacing = spacing + 5
        flowLayout.sectionInset = UIEdgeInsets(top: zoneImageView.frame.height + self.topLayoutGuide.length + 10, left: flowLayout.sectionInset.left, bottom: flowLayout.sectionInset.bottom, right: flowLayout.sectionInset.right)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        tokens.forEach { NSNotificationCenter.defaultCenter().removeObserver($0) }
        tokens.removeAll()
    }

    // MARK: - Helper Functions
    // Tutorial Section 6.3 (Tags)
    func toggleFilterButtonDisplay(isHidden: Bool) {
        if isHidden {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            let filterBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Bookmarks, target: self, action: #selector(ZoneViewController.onFilterAction(_:)))
            self.navigationItem.rightBarButtonItem = filterBarButtonItem
        }
    }

    // Tutorial Section 6.4 (Tags)
    func doMomentQuery() {
        let momentQuery = MomentQuery()
        momentQuery.zoneIDs = [selectedZone.id]
        if let selectedTagFilter = selectedTagFilter {
            momentQuery.momentIDs = selectedTagFilter
        }
        // Was: MomentRequest.GetZoneMoments(zoneID: selectedZone.id) { (moments, pagination, error) -> Void in
        MomentRequest.Query(momentQuery) { (moments, pagination, error) -> Void in
            guard error == nil else {
                print("Encountered error: \(error!)")
                return
            }
            self.moments = moments
            self.momentsCollectionView.reloadData()
        }.execute()
    }

    // Tutorial Section 7.9 (Push Notifications)
    func zoneEnteredMessage(messageInfo: [NSObject: AnyObject]?) {
        // TODO: (TL) Handle messageInfo stuffs
    }

    // MARK: - Segue Functions
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Tutorial Section 4.3 (Moments)
        if let moment = sender as? Moment {
            let momentViewController = segue.destinationViewController as! MomentViewController
            momentViewController.moment = moment
        }
    }

    // MARK: - UICollectionViewDataSource Functions
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Tutorial Section 3.6 (Selected Zone)
        return moments?.count ?? 0
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(MomentCollectionViewCell.Constants.CellReuseIdentifier, forIndexPath: indexPath) as! MomentCollectionViewCell

        // Tutorial Section 3.7 (Selected Zone)
        if let moment = moments?[indexPath.item] {
            moment.image?.loadImage(._100, locale: nil) { (image, error) -> Void in
                guard error == nil else {
                    print("Encountered image loading error: \(error!)")
                    return
                }
                UIView.transitionWithView(cell.momentImageView, duration: 0.2, options: .TransitionCrossDissolve, animations: { () -> Void in
                    cell.momentImageView.image = image.loadedImage()
                }, completion: nil)
            }
        }
        return cell
    }

    // MARK: - UICollectionViewDelegate Functions
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Tutorial Section 4.2 (Moments)
        if let moment = moments?[indexPath.item] {
            self.performSegueWithIdentifier(Constants.MomentSegue, sender: moment)
        }
    }

    // MARK: - IBActions
    // Tutorial Section 6.5 (Tags)
    @IBAction func onFilterAction(sender: UIBarButtonItem) {
        guard let tags = tags else {
            return // Nothing to show
        }
        
        let alertController = UIAlertController(title: nil, message: "Filter By Tag", preferredStyle: .ActionSheet)
        alertController.modalPresentationStyle = .Popover
        alertController.popoverPresentationController?.barButtonItem = sender
        
        
        for tag in tags {
            alertController.addAction(UIAlertAction(title: tag.value?.defaultValue ?? "Tag \(tag.id)", style: .Default) { (action) -> Void in
                self.selectedTagFilter = tag.zoneMomentInstanceIDs
                self.doMomentQuery()
            })
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            // Do nothing
        })
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}