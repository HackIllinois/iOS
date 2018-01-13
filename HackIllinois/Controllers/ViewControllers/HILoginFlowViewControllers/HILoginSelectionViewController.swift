//
//  HILoginSelectionViewController.swift
//  HackIllinois
//
//  Created by Rauhul Varma on 11/30/17.
//  Copyright © 2017 HackIllinois. All rights reserved.
//

import Foundation
import UIKit

protocol HILoginSelectionViewControllerDelegate: class {
    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HILoginSelection)
}

class HILoginSelectionViewController: HIBaseViewController {
    // MARK: - Properties
    weak var delegate: HILoginSelectionViewControllerDelegate?

    // MARK: - Actions
    @IBAction func didSelectHacker(_ button: UIButton) {
        delegate?.loginSelectionViewController(self, didMakeLoginSelection: .hacker)
    }

    @IBAction func didSelectMentor(_ button: UIButton) {
        delegate?.loginSelectionViewController(self, didMakeLoginSelection: .mentor)
    }

    @IBAction func didSelectStaff(_ button: UIButton) {
        delegate?.loginSelectionViewController(self, didMakeLoginSelection: .staff)
    }

    @IBAction func didSelectVolunteer(_ button: UIButton) {
        delegate?.loginSelectionViewController(self, didMakeLoginSelection: .volunteer)
    }
}
