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
    
    var selectedView = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        if selectedView != nil {
            setStartState(selectedSegment: selectedView, segmentView: segmentView, firstView: newMovementView, secondView: movementHistoryView)
        }
            
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
    
    private func setStartState(selectedSegment: Int, segmentView: UISegmentedControl, firstView: UIView, secondView: UIView) {
        
        if selectedSegment == 0 {
            
            segmentView.selectedSegmentIndex = 0
            firstView.alpha = 1
            secondView.alpha = 0
        }
        
        if selectedSegment == 1 {
            
            segmentView.selectedSegmentIndex = 1
            firstView.alpha = 0
            secondView.alpha = 1
        }
        
    }
    

}
