//
//  OutcomeKassaVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/9/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class OutcomeKassaVC: UIViewController {

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var firstPage: UIView!
    @IBOutlet weak var secondPage: UIView!
    
    var history_id_from_list: Int = 0
    var segment_id: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        

        if segment_id == 1 {
            segmentView.selectedSegmentIndex = 1
            firstPage.alpha = 1
            secondPage.alpha = 0
        }
        
        segmentView.removeBorder()
        segmentView.addUnderlineForSelectedSegment()
        
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
    
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let vc = segue.destination as? OutcomeKassaFirstPage,
           segue.identifier == "huiid" {
           vc.history_id_in_list = history_id_from_list
    
    }
    
    }

}
