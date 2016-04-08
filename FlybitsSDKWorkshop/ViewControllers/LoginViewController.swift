//
//  LoginViewController.swift
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2015-12-09.
//  Copyright © 2015 Flybits Inc. All rights reserved.
//

import UIKit
import FlybitsSDK

class LoginViewController: UIViewController {
    struct Constants {
        static let LoginSegue = "LoginSegue"
        static let RotationAnimation = "Rotation"

        static let LogoImageViewOffset: CGFloat = 75
    }

    // MARK: - IBOutlets
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var loginButton: UIButton!

    // MARK: - NSLayoutConstraints
    @IBOutlet var logoImageViewCenterConstraint: NSLayoutConstraint!
    @IBOutlet var logoImageViewTopConstraint: NSLayoutConstraint!

    // MARK: - Properties
    // Tutorial Section 7.3 (Push Notifications)

    var fromUnwindSegue: Bool = false
    var animateLogo: Bool = false {
        didSet {
            if animateLogo {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = M_PI/2
                animation.repeatCount = MAXFLOAT
                animation.toValue = M_PI * 2.0
                animation.fromValue = 0
                logoImageView.layer.addAnimation(animation, forKey: Constants.RotationAnimation)
            } else {
                logoImageView.layer.removeAnimationForKey(Constants.RotationAnimation)
            }
        }
    }

    // MARK: - View Lifecycle Functions
    override func awakeFromNib() {
        // Tutorial Section 7.6 (Push Notifications)
    }

    override func viewDidAppear(animated: Bool) {
        if fromUnwindSegue {
            fromUnwindSegue = false
            reverseLogoAnimation()
        }
    }

    // MARK: - Functions
    func animateLogoAndPerformSegue(sender: UIButton) {
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.emailTextField.hidden = true
            self.passwordTextField.hidden = true
            self.loginButton.hidden = true
            self.logoImageViewTopConstraint.constant = self.view.frame.height / 2 - self.logoImageView.frame.height / 2 - self.topLayoutGuide.length
            self.view.layoutIfNeeded()
        }) { (finished) -> Void in
            self.logoImageViewCenterConstraint.constant = self.view.frame.width
            UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.performSegueWithIdentifier(Constants.LoginSegue, sender: nil)
                self.animateLogo = false
            }
        }
    }

    func reverseLogoAnimation() {
        self.animateLogo = true
        self.logoImageViewCenterConstraint.constant = 0
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (finished) -> Void in
            self.logoImageViewTopConstraint.constant = Constants.LogoImageViewOffset
            UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseInOut, animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                UIView.animateWithDuration(0.5, delay: 0.2, options: .CurveEaseOut, animations: { () -> Void in
                    self.emailTextField.hidden = false
                    self.passwordTextField.hidden = false
                    self.loginButton.hidden = false
                }) { (finished) -> Void in
                    self.animateLogo = false
                    self.loginButton.enabled = true
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction func onLoginAction(sender: UIButton) {
        sender.enabled = false
        animateLogo = true

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        // Tutorial Section 1.1 (Login / Logout)
        self.animateLogoAndPerformSegue(sender)
    }

    @IBAction func onUnwindSegue(segue: UIStoryboardSegue) {
        fromUnwindSegue = true

        // Tutorial Section 1.2 (Login / Logout)
    }
}