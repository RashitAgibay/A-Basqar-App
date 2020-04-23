//
//  MainStoreVC.swift
//  A-Basqar
//
//  Created by iliyas on 23.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainStoreVC: UIViewController {

    
    
    @IBOutlet weak var storesView: UIView!
    @IBOutlet weak var employeeListView: UIView!
    
    @IBOutlet weak var plusBarButton: UIBarButtonItem!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    var selectedView = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setStartState(selectedSegment: selectedView, segmentView: segmentView, firstView: storesView, secondView: employeeListView)
        
        segmentView.addUnderlineForSelectedSegment()
        
    }
    
    @IBAction func switchSegmentAction(_ sender: UISegmentedControl) {
        
        segmentView.changeUnderlinePosition()
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            storesView.alpha  = 1
            employeeListView.alpha = 0
            break
            
        case 1:
            storesView.alpha  = 0
            employeeListView.alpha = 1
            
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
