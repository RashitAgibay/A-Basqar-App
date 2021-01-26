//
//  MainKassaImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/6/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Printer

class MainKassaImportVC: UIViewController {

    
    @IBOutlet weak var newKassaImportView: UIView!
    @IBOutlet weak var historyKassaImportView: UIView!
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
            
            newKassaImportView.alpha = 1
            historyKassaImportView.alpha = 0
            
            segmentView.selectedSegmentIndex = 0
            
        case 1:
            
            newKassaImportView.alpha = 0
            historyKassaImportView.alpha = 1
            
            segmentView.selectedSegmentIndex = 1
            
        default:
            break
        }
    }
    
    @IBAction func switchSegment(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            
            newKassaImportView.alpha = 1
            historyKassaImportView.alpha = 0
            
        case 1:
            
            newKassaImportView.alpha = 0
            historyKassaImportView.alpha = 1
            
        default:
            break
        }
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as?
            BluetoothPrinterSelectTableViewController {
            
            let bluetoothPrinterManager = appDelegate.bluetoothPrinterManager

            vc.sectionTitle = "Choose Bluetooth Printer"
            vc.printerManager = bluetoothPrinterManager
        }
    }
}
