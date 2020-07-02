//
//  MainImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 6/30/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainImportVC: UIViewController {

    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var newImportView: UIView!
    @IBOutlet weak var historyImportView: UIView!

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
            
            newImportView.alpha = 1
            historyImportView.alpha = 0
            
        case 1:
            
            newImportView.alpha = 0
            historyImportView.alpha = 1
            
        default:
            break
        }
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            newImportView.alpha = 1
            historyImportView.alpha = 0
            
        case 1:
            
            newImportView.alpha = 0
            historyImportView.alpha = 1
            
        default:
            break
        }
        
    }

}
