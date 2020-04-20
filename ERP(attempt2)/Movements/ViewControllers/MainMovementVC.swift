//
//  MainMovementVC.swift
//  A-Basqar
//
//  Created by iliyas on 20.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainMovementVC: UIViewController {

    
    @IBOutlet weak var homeBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var barcodeBarButton: UIBarButtonItem!
    @IBOutlet weak var plusBarButton: UIBarButtonItem!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var newMovementView: UIView!
    @IBOutlet weak var movementHistoryView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        segmentView.addUnderlineForSelectedSegment()

    }
    

    @IBAction func switchSegmentAction(_ sender: UISegmentedControl) {
        
        segmentView.changeUnderlinePosition()

        switch sender.selectedSegmentIndex {
        case 0:
            newMovementView.alpha  = 1
            movementHistoryView.alpha = 0
            break
            
        case 1:
            newMovementView.alpha = 0
            movementHistoryView.alpha = 1
        default:
            break
        }
    }
    
    

}
