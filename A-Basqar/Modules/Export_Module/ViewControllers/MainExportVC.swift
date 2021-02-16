//
//  MainExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainExportVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var newExportView: UIView!
    @IBOutlet weak var historyExportView: UIView!

    var selectegTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBaseFuncs()
    }

    private func setupUI() {
        segmentControl.setupSimpleView()
    }
    
    private func setupBaseFuncs() {
        switch selectegTag {
        case 0:
            newExportView.alpha = 1
            historyExportView.alpha = 0
            segmentControl.selectedSegmentIndex = 0
        case 1:
            newExportView.alpha = 0
            historyExportView.alpha = 1
            segmentControl.selectedSegmentIndex = 1
        default:
            break
        }
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            newExportView.alpha = 1
            historyExportView.alpha = 0
        case 1:
            newExportView.alpha = 0
            historyExportView.alpha = 1
        default:
            break
        }
    }
}
