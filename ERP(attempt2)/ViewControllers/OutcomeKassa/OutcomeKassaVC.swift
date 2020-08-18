//
//  OutcomeKassaVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/9/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit
import Printer


//some changes 
class OutcomeKassaVC: UIViewController {

    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var firstPage: UIView!
    @IBOutlet weak var secondPage: UIView!
    
    var history_id_from_list: Int = 0
    var segment_id: Int = 0
    
    var company_id: Int = 0
    var company_name: String = ""
    
    
    
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
    
    if let vc = segue.destination as? BluetoothPrinterSelectTableViewController {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let bluetoothPrinterManager = appDelegate.bluetoothPrinterManager
        
        vc.sectionTitle = "Выберите принтер"
        vc.printerManager = bluetoothPrinterManager
    }
    
    if let vc = segue.destination as? OutcomeKassaFirstPage,
        segue.identifier == "huiid" {
        vc.history_id_in_list = history_id_from_list
        vc.company_id = company_id
        vc.companyName = company_name
    }
    }

}
