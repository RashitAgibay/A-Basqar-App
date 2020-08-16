//
//  MainReportPageVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/9/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainReportPageVC: UIViewController {

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var firstPage: UIView!
    @IBOutlet weak var secondPage: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentView.setupSimpleView()
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        
        segmentView.changeUnderlinePosition()
        
        switch sender.selectedSegmentIndex {
        case 0:
            firstPage.alpha  = 0
            secondPage.alpha = 1
            break
            
        case 1:
            firstPage.alpha = 1
            secondPage.alpha = 0
        default:
            break
        }
        
    }
    
   

}
