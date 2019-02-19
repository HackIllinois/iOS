//
//  HILocalNotificationController.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 2/22/18.
//  Copyright © 2018 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import UserNotifications
import UIKit
import HIAPI

class HILocalNotificationController: NSObject {
    static let shared = HILocalNotificationController()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestAuthorization(authorized: (() -> Void)? = nil) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .authorized: authorized?()
            case .denied: break
            case .notDetermined:
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, _) in
                    if granted { authorized?() }
                }
            case .provisional: break
            }
        }
    }

    func scheduleNotifications(for events: [Event]) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let favoritedEvents = events.filter { $0.favorite }

        for event in favoritedEvents {
            scheduleNotification(for: event)
        }
    }

    func scheduleNotification(for event: Event) {
        requestAuthorization {
            let scheduleDelay: TimeInterval = 10
            let secondsPerMinute: TimeInterval = 60
            let timeBeforeEventStartForNotification = scheduleDelay * secondsPerMinute

            let now = Date()
            guard event.startTime > now else { return }
            let timeIntervalUntilEventStart = event.startTime.timeIntervalSince(now)
            let triggerDelay = max(1, timeIntervalUntilEventStart - timeBeforeEventStartForNotification)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: triggerDelay, repeats: false)

            let content = UNMutableNotificationContent()
            let minutesUntilEvent = min(10, Int(timeIntervalUntilEventStart/secondsPerMinute))
            if minutesUntilEvent <= 1 {
                content.title = "\(event.name) starts now!"
            } else {
                content.title = "\(event.name) starts in \(minutesUntilEvent) minutes!"
            }
            content.body = event.info
            content.sound = UNNotificationSound.default

            let request = UNNotificationRequest(identifier: event.name, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request)
        }
    }

    func unscheduleNotification(for event: Event) {
        requestAuthorization {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(event.name)"])
        }
    }
}

extension HILocalNotificationController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .alert])
        HIAnnouncementDataSource.injectAnnouncement(notification: notification)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
