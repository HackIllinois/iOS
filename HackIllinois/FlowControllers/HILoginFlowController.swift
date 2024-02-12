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
import AuthenticationServices
import APIManager
import Lottie
import SafariServices
import Keychain
import HIAPI

#warning("ASWebAuthticationSession not tested")
class HILoginFlowController: UIViewController {
    // MARK: - Properties

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
    var loginSession: ASWebAuthenticationSession?
    var eventsSession: ASWebAuthenticationSession?

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

// add ASWebAuthenticationPresentationContextProviding to the class
extension HILoginFlowController: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
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
}

// MARK: - Login Flow
private extension HILoginFlowController {
    private func attemptOAuthLogin(buildingUser user: HIUser, profile: HIProfile, sender: HIBaseViewController) {
        //GUEST (bypass auth)
        if user.provider == .guest {
            var guestUser = HIUser()
            var guestProfile = HIProfile()
            guestUser.provider = .guest
            guestProfile.provider = .guest
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": guestUser])
                NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": guestProfile])
            }
            return
        }
        
        let loginURL = HIAPI.AuthService.oauthURL(provider: user.provider)
        NSLog(loginURL.description)
        loginSession = ASWebAuthenticationSession(url: loginURL, callbackURLScheme: "hackillinois", completionHandler: { [weak self] (url, error) in
            if let url = url,
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                let queryItems = components.queryItems,
                let token = queryItems.first(where: { $0.name == "token" })?.value, // Get token
                token.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    NSLog(token)
                    var user = user
                    var profile = profile
                    user.token = token
                    profile.token = token
                    self?.populateUserData(buildingUser: user, profile: profile, sender: sender) // Populate user
            } else if let error = error {
                if (error as? ASWebAuthenticationSessionError)?.code == ASWebAuthenticationSessionError.canceledLogin {
                    // do nothing
                } else {
                    self?.presentAuthenticationFailure(withError: error, sender: sender)}
            } else {
                let error = HIError.unknownAuthenticationError
                self?.presentAuthenticationFailure(withError: error, sender: sender)
            }
        })
        loginSession?.prefersEphemeralWebBrowserSession = true
        loginSession?.presentationContextProvider = self
        loginSession?.start()
    }

    // For HackIllinois 2024, this function is not being used
    private func exchangeOAuthCodeForAPIToken(buildingUser user: HIUser, profile: HIProfile, sender: HIBaseViewController) {
        HIAPI.AuthService.getAPIToken(provider: user.provider)
        .onCompletion { [weak self] result in
            do {
                let (apiToken, _) = try result.get()
                var user = user
                var profile = profile
                user.token = apiToken.token
                profile.token = apiToken.token
                NSLog(apiToken.token)
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
                user.userId = apiUser.userId
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
                if user.provider == .github && user.roles.contains(.ATTENDEE) {
                    self?.populateProfileData(buildingProfile: profile, sender: sender)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": user])
                    }
                } else if user.provider == .google {
                    if user.roles.contains(.STAFF) {
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": user])
                            NotificationCenter.default.post(name: .loginProfile, object: nil, userInfo: ["profile": profile])
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

    private func populateProfileData(buildingProfile profile: HIProfile, sender: HIBaseViewController) {
        guard let user = HIApplicationStateController.shared.user else { return }
        HIAPI.ProfileService.getUserProfile(userToken: user.token)
        .onCompletion { [weak self] result in
            do {
                let (apiProfile, _) = try result.get()
                var profile = profile
                profile.userId = apiProfile.userId
                profile.displayName = apiProfile.displayName
                profile.points = apiProfile.points
                profile.discordTag = apiProfile.discordTag
                profile.avatarUrl = apiProfile.avatarUrl
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
