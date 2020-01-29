//
//  IncomeKassaVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/6/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class IncomeKassaVC: UIViewController {

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var firstPageView: UIView!
    @IBOutlet weak var segmentViewPage: UIView!
    
    var history_id_from_list: Int = 0
    var segment_id: Int = 0
    
    var company_id: Int = 0
    var company_name: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()


        if segment_id == 1 {
            segmentView.selectedSegmentIndex = 1
            firstPageView.alpha = 1
            segmentViewPage.alpha = 0
        }
        
        segmentView.removeBorder()
        segmentView.addUnderlineForSelectedSegment()
     
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    if let vc = segue.destination as? FirstPageVC,
        segue.identifier == "onemoremoreid" {
        
        vc.history_id_in_list = history_id_from_list
        vc.company_id = company_id
        vc.companyName = company_name
        }
    }
    

    @IBAction func swithSegment(_ sender: UISegmentedControl) {
        
        segmentView.changeUnderlinePosition()
                      
                      switch sender.selectedSegmentIndex {
                      case 0:
                          firstPageView.alpha  = 0
                          segmentViewPage.alpha = 1
                          break
                          
                      case 1:
                          firstPageView.alpha = 1
                          segmentViewPage.alpha = 0
                      default:
                          break
                      }
        
    }
}
