//
//  MainBidVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainBidVC: UIViewController {

    @IBOutlet weak var homeBarButton: UIBarButtonItem!
    @IBOutlet weak var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var barcodeBarButton: UIBarButtonItem!
    @IBOutlet weak var plusBarButton: UIBarButtonItem!
    @IBOutlet weak var segmentView: UISegmentedControl!
    
    @IBOutlet weak var newBidView: UIView!
    @IBOutlet weak var currentBidsView: UIView!
    @IBOutlet weak var bidsHistoryView: UIView!
    
    var selectedView = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        setStartState(selectedSegment: selectedView, segmentView: segmentView, firstView: newBidView, secondView: currentBidsView, thirdView: bidsHistoryView)
        
        segmentView.addUnderlineForSelectedSegment()

    }
    

    @IBAction func switchSegmentAction(_ sender: UISegmentedControl) {
        
        segmentView.changeUnderlinePosition()
        
        switch sender.selectedSegmentIndex {
        case 0:
            newBidView.alpha  = 1
            currentBidsView.alpha = 0
            bidsHistoryView.alpha = 0
            break
            
        case 1:
            newBidView.alpha  = 0
            currentBidsView.alpha = 1
            bidsHistoryView.alpha = 0
            
        case 2:
            newBidView.alpha  = 0
            currentBidsView.alpha = 0
            bidsHistoryView.alpha = 1
        default:
            break
        }
        
    }

    private func setStartState(selectedSegment: Int, segmentView: UISegmentedControl, firstView: UIView, secondView: UIView, thirdView: UIView) {
        
//        print(selectedSegment)
        
        if selectedSegment == 0 {
            
            segmentView.selectedSegmentIndex = 0
            firstView.alpha = 1
            secondView.alpha = 0
            thirdView.alpha = 0
        }
        
        if selectedSegment == 1 {
            
            segmentView.selectedSegmentIndex = 1
            firstView.alpha = 0
            secondView.alpha = 1
            thirdView.alpha = 0
        }
        
        if selectedSegment == 2 {
            
            segmentView.selectedSegmentIndex = 2
            firstView.alpha = 0
            secondView.alpha = 0
            thirdView.alpha = 1
        }
        
    }
}
