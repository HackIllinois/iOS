//
//  HILoginFlowController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 12/2/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import UIKit
import APIManager
import Lottie
import SafariServices
import Keychain
import HIAPI

class HILoginFlowController: UIViewController {
    // MARK: - Properties
    let animationView = AnimationView(name: "intro")
    var shouldDisplayAnimationOnNextAppearance = true
    let animationBackgroundView = UIImageView()

    // MARK: Status Bar
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    var statusBarIsHidden = false
    override var prefersStatusBarHidden: Bool {
        return statusBarIsHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return (\HIAppearance.preferredStatusBarStyle).value
    }

    // prevents the login session from going out of scope during presentation
    var loginSession: SFAuthenticationSession?

    // MARK: ViewControllers
    lazy var loginSelectionViewController = HILoginSelectionViewController(delegate: self)

    // MARK: - Init
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshForThemeChange), name: .themeDidChange, object: nil)
        refreshForThemeChange()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) should not be used")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Themeable
    @objc func refreshForThemeChange() {
        setNeedsStatusBarAppearanceUpdate()
    }
}

// MARK: - UIViewController
extension HILoginFlowController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor <- \.baseBackground
        addChild(loginSelectionViewController)
        loginSelectionViewController.view.frame = view.frame
        loginSelectionViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(loginSelectionViewController.view)
        loginSelectionViewController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if shouldDisplayAnimationOnNextAppearance {
            animationView.contentMode = .scaleAspectFill
            animationView.frame = view.frame
            animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(animationView)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldDisplayAnimationOnNextAppearance {
            statusBarIsHidden = true
            setNeedsStatusBarAppearanceUpdate()

            animationView.play { _ in
                // Smooth out background transition into login page
                UIView.animate(withDuration: 0.3, animations: {self.animationBackgroundView.alpha = 0.0},
                completion: { _ in
                    self.animationBackgroundView.removeFromSuperview()
                })
                self.animationView.removeFromSuperview()
                self.statusBarIsHidden = false
                UIView.animate(withDuration: 0.25) { () -> Void in
                    self.setNeedsStatusBarAppearanceUpdate()
                }
            }
            shouldDisplayAnimationOnNextAppearance = false
        }
    }
}

// MARK: - Login Flow
private extension HILoginFlowController {
    private func attemptOAuthLogin(buildingUser user: HIUser, profile: HIProfile, sender: HIBaseViewController) {

        //GUEST (bypass auth)
        if user.provider == .guest {
            var guestUser = HIUser()
            guestUser.provider = .guest
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": guestUser])
                self.populateDefaultProfileData()
            }
            return
        }

        let loginURL = HIAPI.AuthService.oauthURL(provider: user.provider)
        loginSession = SFAuthenticationSession(url: loginURL, callbackURLScheme: nil) { [weak self] (url, error) in
            if let url = url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems,
                let code = queryItems.first(where: { $0.name == "code" })?.value,
                code.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                var user = user
                var profile = profile
                user.oauthCode = code
                profile.oauthCode = code
                self?.exchangeOAuthCodeForAPIToken(buildingUser: user, profile: profile, sender: sender)
            } else if let error = error {
                if (error as? SFAuthenticationError)?.code == SFAuthenticationError.canceledLogin {
                    // do nothing
                } else {
                    self?.presentAuthenticationFailure(withError: error, sender: sender)
                }
            } else {
                let error = HIError.unknownAuthenticationError
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        loginSession?.start()
    }

    private func exchangeOAuthCodeForAPIToken(buildingUser user: HIUser, profile: HIProfile, sender: HIBaseViewController) {
        HIAPI.AuthService.getAPIToken(provider: user.provider, code: user.oauthCode)
        .onCompletion { [weak self] result in
            do {
                let (apiToken, _) = try result.get()
                var user = user
                var profile = profile
                user.token = apiToken.token
                profile.token = apiToken.token
                self?.populateUserData(buildingUser: user, profile: profile, sender: sender)
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .launch()
    }

    private func populateUserData(buildingUser user: HIUser, profile: HIProfile, sender: HIBaseViewController) {
        subscribeUserToRelevantTopics(buildingUser: user, sender: sender)
        HIAPI.UserService.getUser()
        .onCompletion { [weak self] result in
            do {
                let (apiUser, _) = try result.get()
                var user = user
                user.id = apiUser.id
                user.username = apiUser.username
                user.firstName = apiUser.firstName
                user.lastName = apiUser.lastName
                user.email = apiUser.email
                self?.populateRoleData(buildingUser: user, profile: profile, sender: sender)
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .authorize(with: user)
        .launch()
    }

    private func subscribeUserToRelevantTopics(buildingUser user: HIUser, sender: HIBaseViewController) {
        HIAPI.AnnouncementService.updateSubscriptions()
        .authorize(with: user)
        .launch()
    }

    private func populateRoleData(buildingUser user: HIUser, profile: HIProfile, sender: HIBaseViewController) {
        HIAPI.AuthService.getRoles()
        .onCompletion { [weak self] result in
            do {
                let (apiRolesContainer, _) = try result.get()
                var user = user
                var profile = profile
                user.roles = apiRolesContainer.roles
                profile.roles = apiRolesContainer.roles
                if user.provider == .github && user.roles.contains(.attendee) {
                    self?.populateRegistrationData(buildingUser: user, profile: profile, sender: sender)
                } else if user.provider == .google {
                    if user.roles.contains(.staff) {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": user])
                            self?.populateDefaultProfileData()
                        }
                    } else {
                        DispatchQueue.main.async {
                            sender.presentErrorController(title: "You must have a valid staff account to log in.", message: "", dismissParentOnCompletion: false)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        sender.presentErrorController(title: "You must RSVP to log in.", message: "", dismissParentOnCompletion: false)
                    }
                }
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .authorize(with: user)
        .launch()
    }

    private func populateRegistrationData(buildingUser user: HIUser, profile: HIProfile, sender: HIBaseViewController) {
        HIAPI.RegistrationService.getAttendee()
        .onCompletion { [weak self] result in
            do {
                let (apiAttendeeContainer, _) = try result.get()
                var user = user
                var profile = profile
                user.attendee = apiAttendeeContainer.attendee
                profile.attendee = apiAttendeeContainer.attendee
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": user])
                }
                self?.populateProfileData(buildingProfile: profile, sender: sender)
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        }
        .authorize(with: user)
        .launch()
    }

    private func populateDefaultProfileData() {
        var profile = HIProfile()
        profile.firstName = "Default"
        profile.lastName = "Account"
        profile.points = 0
        profile.timezone = "CDT"
        profile.info = "This is a default account."
        profile.discord = "N/A"
        profile.avatarUrl = "https://hackillinois-upload.s3.amazonaws.com/photos/profiles-2021/profile-0.png"
        profile.teamStatus = "NOT_LOOKING"
        profile.interests = []
        NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": profile])
    }

    private func populateProfileData(buildingProfile profile: HIProfile, sender: HIBaseViewController) {
        HIAPI.ProfileService.getUserProfile()
        .onCompletion { [weak self] result in
            do {
                let (apiProfile, _) = try result.get()
                var profile = profile
                profile.id = apiProfile.id
                profile.firstName = apiProfile.firstName
                profile.lastName = apiProfile.lastName
                profile.points = apiProfile.points
                profile.timezone = apiProfile.timezone
                profile.info = apiProfile.info
                profile.discord = apiProfile.discord
                profile.avatarUrl = apiProfile.avatarUrl
                profile.teamStatus = apiProfile.teamStatus
                profile.interests = apiProfile.interests
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": profile])
                }
            } catch {
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }

        }
        .authorize(with: profile)
        .launch()

    }

    private func presentAuthenticationFailure(withError error: Error, sender: HIBaseViewController) {
        DispatchQueue.main.async {
            sender.presentErrorController(title: "Authentication Failed", message: String(describing: error), dismissParentOnCompletion: false)
        }
    }
}

// MARK: - HILoginSelectionViewControllerDelegate
extension HILoginFlowController: HILoginSelectionViewControllerDelegate {
    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController,
                                      didMakeLoginSelection selection: HIAPI.AuthService.OAuthProvider) {
        let user = HIUser(provider: selection)
        let profile = HIProfile(provider: selection)
        attemptOAuthLogin(buildingUser: user, profile: profile, sender: loginSelectionViewController)
    }
}
