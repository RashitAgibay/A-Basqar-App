//
//  MainKassaExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/11/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainKassaExportVC: UIViewController {

    
    @IBOutlet weak var newKassaExportView: UIView!
    @IBOutlet weak var historyKassaExportView: UIView!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    var selectegTag = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupBaseFuncs()


    }
    
    private func setupUI() {
        
        segmentView.setupSimpleView()

    }
    
    private func setupBaseFuncs() {
        
        switch selectegTag {
        case 0:
            
            newKassaExportView.alpha = 1
            historyKassaExportView.alpha = 0
            
            segmentView.selectedSegmentIndex = 0
            
        case 1:
            
            newKassaExportView.alpha = 0
            historyKassaExportView.alpha = 1
            
            segmentView.selectedSegmentIndex = 1
            
        default:
            break
        }
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            newKassaExportView.alpha = 1
            historyKassaExportView.alpha = 0
            
        case 1:
            
            newKassaExportView.alpha = 0
            historyKassaExportView.alpha = 1
            
        default:
            break
        }
    }
    

}
