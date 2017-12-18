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
    func loginSelectionViewController(_ loginSelectionViewController: HILoginSelectionViewController, didMakeLoginSelection selection: HILoginSelectionViewController.SelectionType)
}

class HILoginSelectionViewController: HIBaseViewController {

    enum SelectionType {
        case hacker
        case mentor
        case staff
        case volunteer
    }

    weak var delegate: HILoginSelectionViewControllerDelegate?

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
