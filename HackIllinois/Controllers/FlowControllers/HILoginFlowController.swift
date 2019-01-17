//
//  HILoginFlowController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 12/2/17.
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
import SwiftKeychainAccess

class HILoginFlowController: UIViewController {
    // MARK: - Properties
    let animationView = LOTAnimationView(name: "intro")
    var shouldDisplayAnimationOnNextAppearance = true
    var userPassRequest: APIRequest<HIAPIUserAuth.Contained>?
    var keychainContents = [String]()

    // MARK: Status Bar
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }

    var statusBarIsHidden = false
    override var prefersStatusBarHidden: Bool {
        return statusBarIsHidden
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return HIAppearance.current.preferredStatusBarStyle
    }

    // keeps the login session from going out of scope during presentation
    var loginSession: SFAuthenticationSession?

    // MARK: ViewControllers
    lazy var navController = UINavigationController(rootViewController: loginSelectionViewController)
    lazy var loginSelectionViewController = HILoginSelectionViewController(delegate: self)
    lazy var userPassLoginViewController = HIUserPassLoginViewController(delegate: self)

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
        view.backgroundColor = HIAppearance.current.background
        navController.isNavigationBarHidden = true
        addChild(navController)
        navController.view.frame = view.frame
        navController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(navController.view)
        navController.didMove(toParent: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshKeychainContents()
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
extension HILoginFlowController {
    func getUserTokenFromCode(code: String) {
        let json: [String: Any] = ["code": code]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // create post request
        let url = URL(string: "https://api.hackillinois.org/auth/code/github/?redirect_uri=https://test.hackillinois.org/auth/?isiOS=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // insert json data to the request
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                if let token = responseJSON["token"] as? String {
                    let tok = token.trimmingCharacters(in: .whitespacesAndNewlines)
                    DispatchQueue.main.async {
                        self.populateUserData(loginMethod: .github, token: tok, sender: self.loginSelectionViewController)
                    }
                }
            }
        }
        task.resume()
    }
}

// MARK: - Login Flow
extension HILoginFlowController {
    func getUserFromJSON(responseData: Data, loginMethod: HILoginMethod, token: String) -> HIUser? {
        do {
            let json = try JSONSerialization.jsonObject(with: responseData, options: JSONSerialization.ReadingOptions.allowFragments)
            var id = 0
            var email = ""
            var firstName = ""
            var lastName = ""
            if let dictionary = json as? [String: Any] {
                if let dictId = dictionary["id"] as? Int {
                    // access individual value in dictionary
                    id = dictId
                }
                if let dictEmail = dictionary["email"] as? String {
                    // access individual value in dictionary
                    email = dictEmail
                }
                if let dictFirstName = dictionary["firstName"] as? String {
                    // access individual value in dictionary
                    firstName = dictFirstName
                }
                if let dictLastName = dictionary["lastName"] as? String {
                    // access individual value in dictionary
                    lastName = dictLastName
                }
            }
            return HIUser(
                loginMethod: loginMethod,
                permissions: HIUserPermissions(rawValue: "ATTENDEE")!,
                token: token,
                identifier: email,
                isActive: true,
                id: id,
                name: firstName + " " + lastName,
                dietaryRestrictions: nil
            )
        } catch { return nil }
    }
    func populateUserData(loginMethod: HILoginMethod, token: String, sender: HIBaseViewController) {
        var request = URLRequest(url: URL(string: "https://api.hackillinois.org/user/")!)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let responseData = data {
                var user = self.getUserFromJSON(responseData: responseData, loginMethod: loginMethod, token: token)
                HIRegistrationService.getAttendee(by: token, with: loginMethod)
                    .onCompletion { result in
                        switch result {
                        case .success(let containedAttendee, _):
                            let attendeeInfo = containedAttendee.data[0]
                            let names = [attendeeInfo.firstName, attendeeInfo.lastName].compactMap { $0 } as [String]
                            user?.name = names.joined(separator: " ")
                            user?.dietaryRestrictions = attendeeInfo.diet
                        case .failure:
                            break
                        }
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: ["user": user as Any])
                        }
                    }
                    .launch()
            }
            }.resume()
    }
}

// MARK: - Keychain
extension HILoginFlowController {
    func refreshKeychainContents() {
        keychainContents = Keychain.default.allKeys().sorted { $0 < $1 }
        loginSelectionViewController.tableView?.reloadData()
    }

    func keychainRetrievalSucceeded(user: HIUser) {
        NotificationCenter.default.post(name: .loginUser, object: nil, userInfo: [
            "user": user
            ])
    }
    func keychainRetrievalFailed(id: String) {
        Keychain.default.removeObject(forKey: id)
        refreshKeychainContents()
        let alert = UIAlertController(title: "Login Failed", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - HILoginSelectionViewControllerDelegate
extension HILoginFlowController: HILoginSelectionViewControllerDelegate {
    func loginSelectionViewControllerKeychainAccounts(_ loginSelectionViewController: HILoginSelectionViewController) -> [String] {
        return keychainContents
    }

    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController,
                                      didMakeLoginSelection selection: HILoginSelection,
                                      withUserInfo info: String?) {
        switch selection {
        case .github:
            loginSession = SFAuthenticationSession(url: URL(string: "https://api.hackillinois.org/auth/github/?redirect_uri=https://test.hackillinois.org/auth/?isiOS=1")!, callbackURLScheme: "https://test.hackillinois.org/auth/?isiOS=1") { [weak self] (url, error) in
                if let url = url,
                    let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
                    let queryItems = components.queryItems,
                    let code = queryItems.first(where: { $0.name == "code" })?.value,
                    code.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
                    DispatchQueue.main.async {
                        self?.getUserTokenFromCode(code: code)
                    }
                }
                if let error = error {
                    if (error as? SFAuthenticationError)?.code == SFAuthenticationError.canceledLogin {
                        // do nothing
                    } else {
                        let alert = UIAlertController(title: "Authentication Failed", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
            loginSession?.start()

        case .userPass:
            navController.pushViewController(userPassLoginViewController, animated: true)

        case .existing:
            guard let identifier = info else { break }

            if let user = Keychain.default.retrieve(HIUser.self, forKey: identifier) {
                keychainRetrievalSucceeded(user: user)
            } else {
                keychainRetrievalFailed(id: identifier)
            }
        }
    }
}

// MARK: - HIUserPassLoginViewControllerDelegate
extension HILoginFlowController: HIUserPassLoginViewControllerDelegate {
    func userPassLoginViewControllerDidSelectBackButton(_ userPassLoginViewController: HIUserPassLoginViewController) {
        // FIX ME, @rauhul needs to release a new API-manager that exposes this property
        // if userPassRequest?.state == .running {
        //     userPassRequest?.cancel()
        //     userPassRequest = nil
        // }
        navController.popViewController(animated: true)
    }

    func userPassLoginViewControllerDidSelectLoginButton(_ userPassLoginViewController: HIUserPassLoginViewController, forEmail email: String, andPassword password: String) {
        userPassLoginViewController.stylizeFor(.currentlyPerformingLogin)

        userPassRequest = HIAuthService.login(email: email, password: password)
            .onCompletion { result in
                switch result {
                case .success(let containedAuth, _):
                    DispatchQueue.main.async { [weak self] in
                        self?.populateUserData(loginMethod: .userPass, token: containedAuth.data[0].auth, sender: userPassLoginViewController)
                        self?.userPassLoginViewController.stylizeFor(.readyToLogin)
                    }

                case .failure(let error):
                    do {
                        throw error
                    } catch DecodingError.dataCorrupted(let context) {
                        print("DecodingError.dataCorrupted", context)
                    } catch DecodingError.keyNotFound(let key, let context) {
                        print("DecodingError.keyNotFound", key, context)
                    } catch DecodingError.typeMismatch(let type, let context) {
                        print("DecodingError.typeMismatch", type, context)
                    } catch {
                        print(error)
                    }

                    DispatchQueue.main.async { [weak self] in
                        self?.userPassLoginViewController.shakeWithError()
                        self?.userPassLoginViewController.stylizeFor(.readyToLogin)
                    }
                }
            }
            .launch()
    }
}
