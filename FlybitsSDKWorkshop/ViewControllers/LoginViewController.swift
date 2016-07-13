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
    var apnsToken: Data?
    var notificationToken: NSObjectProtocol?

    var fromUnwindSegue: Bool = false
    var animateLogo: Bool = false {
        didSet {
            if animateLogo {
                let animation = CABasicAnimation(keyPath: "transform.rotation.z")
                animation.duration = M_PI/2
                animation.repeatCount = MAXFLOAT
                animation.toValue = M_PI * 2.0
                animation.fromValue = 0
                logoImageView.layer.add(animation, forKey: Constants.RotationAnimation)
            } else {
                logoImageView.layer.removeAnimation(forKey: Constants.RotationAnimation)
            }
        }
    }

    // MARK: - View Lifecycle Functions
    override func awakeFromNib() {
        // Tutorial Section 7.6 (Push Notifications)
        notificationToken = NotificationCenter.default().addObserver(forName: AppDelegate.Constants.ReceivedToken, object: nil, queue: nil) { (notification) in
            if let userInfo = (notification as NSNotification).userInfo, apnsToken = userInfo[AppDelegate.Constants.TokenKey] as? Data {
                self.apnsToken = apnsToken
                if Session.sharedInstance.status == .connected {
                    PushManager.sharedManager.configuration.apnsToken = apnsToken
                }
            }
            NotificationCenter.default().removeObserver(self.notificationToken!)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        if fromUnwindSegue {
            fromUnwindSegue = false
            reverseLogoAnimation()
        }
    }

    // MARK: - Functions
    func animateLogoAndPerformSegue(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            self.emailTextField.isHidden = true
            self.passwordTextField.isHidden = true
            self.loginButton.isHidden = true
            self.logoImageViewTopConstraint.constant = self.view.frame.height / 2 - self.logoImageView.frame.height / 2 - self.topLayoutGuide.length
            self.view.layoutIfNeeded()
        }) { (finished) -> Void in
            self.logoImageViewCenterConstraint.constant = self.view.frame.width
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseIn, .curveEaseOut], animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                self.performSegue(withIdentifier: Constants.LoginSegue, sender: nil)
                self.animateLogo = false
            }
        }
    }

    func reverseLogoAnimation() {
        self.animateLogo = true
        self.logoImageViewCenterConstraint.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: { () -> Void in
            self.view.layoutIfNeeded()
        }) { (finished) -> Void in
            self.logoImageViewTopConstraint.constant = Constants.LogoImageViewOffset
            UIView.animate(withDuration: 0.5, delay: 0.2, options: [.curveEaseIn, .curveEaseOut], animations: { () -> Void in
                self.view.layoutIfNeeded()
            }) { (finished) -> Void in
                UIView.animate(withDuration: 0.5, delay: 0.2, options: .curveEaseOut, animations: { () -> Void in
                    self.emailTextField.isHidden = false
                    self.passwordTextField.isHidden = false
                    self.loginButton.isHidden = false
                }) { (finished) -> Void in
                    self.animateLogo = false
                    self.loginButton.isEnabled = true
                }
            }
        }
    }

    // MARK: - IBActions
    @IBAction func onLoginAction(_ sender: UIButton) {
        sender.isEnabled = false
        animateLogo = true

        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        // Tutorial Section 1.1 (Login / Logout)
        _ = SessionRequest.login(email: email, password: password, rememberMe: false, fetchJWT: true) { (user, error) -> Void in
            guard error == nil else {
                self.errorLabel.text = "Login Error"
                self.animateLogo = false
                print("Encountered error: \(error)")
                sender.isEnabled = true
                return
            }
            guard user != nil else {
                self.errorLabel.text = "Invalid User"
                self.animateLogo = false
                sender.isEnabled = true
                return
            }
            self.errorLabel.text = ""
            
            // Tutorial Section 7.4 (Push Notifications)
            if let apnsToken = self.apnsToken {
                PushManager.sharedManager.configuration = PushConfiguration(serviceLevel: .both, apnsToken: apnsToken)
            } else {
                PushManager.sharedManager.configuration = PushConfiguration(serviceLevel: .foreground)
            }

            // Tutorial Section 8.1 (Context Data)
            Session.sharedInstance.trackLocation = true
            ContextManager.sharedManager.startDataPolling()

            self.animateLogoAndPerformSegue(sender)
        }.execute()
    }

    @IBAction func onUnwindSegue(_ segue: UIStoryboardSegue) {
        fromUnwindSegue = true

        // Tutorial Section 1.2 (Login / Logout)
        _ = SessionRequest.logout { (success, error) -> Void in
            // Ignore result for this example
        }.execute()
    }
}
