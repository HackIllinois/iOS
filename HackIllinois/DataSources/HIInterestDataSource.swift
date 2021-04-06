//
//  HIInterestDataSource.swift
//  HackIllinois
//
//  Created by HackIllinois Team on 4/5/21.
//  Copyright © 2021 HackIllinois. All rights reserved.
//  This file is part of the Hackillinois iOS App.
//  The Hackillinois iOS App is open source software, released under the University of
//  Illinois/NCSA Open Source License. You should have received a copy of
//  this license in a file with the distribution.
//

import Foundation
import HIAPI
import os

final class HIInterestDataSource {
    static var shared = HIInterestDataSource()

    // swiftlint:disable line_length
    public static let defaultInterestOptions = ["Adobe Illustrator", "Adobe InDesign", "Adobe Photoshop", "Adobe XD", "Android", "Angular", "Arduino", "AWS", "Azure", "Blender", "C", "C#", "C++", "Canva", "CSS", "Digital Ocean", "Django", "Figma", "Firebase", "Flutter", "Git", "GitHub", "Go", "Godot", "Google Cloud", "Haskell", "HTML", "iOS", "Java", "JavaScript", "Kotlin", "MongoDB", "MySQL", "NativeScript", "Neo4J", "PHP", "PostgreSQL", "Python", "Raspberry Pi", "React", "React Native", "Ruby", "Rust", "Swift", "TypeScript", "Unity", "Unreal", "Vue"]

    var interestOptions = HIInterestDataSource.defaultInterestOptions

    private init() {
        self.updateInterests()
    }

    ///Returns whether interest options have been updated or not with synchronous api call to get interest options
    func updateInterests() {
        let semaphore = DispatchSemaphore(value: 0)

        // Update the interest options
        InterestService.getInterests()
            .onCompletion { result in
                do {
                    let (interestContainer, _) = try result.get()
                    self.interestOptions = interestContainer.options
                } catch {
                    os_log(
                        "Unable to update interest options, setting default HackIllinois 2021 interest options: %s",
                        log: Logger.api,
                        type: .error,
                        String(describing: error)
                    )
                }
                semaphore.signal()
            }
            .launch()

        //Synchronous API call to get interest options
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
}
