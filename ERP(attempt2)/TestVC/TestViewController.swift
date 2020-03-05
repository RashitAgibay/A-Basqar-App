//
//  TestViewController.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 3/5/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Printer

class TestViewController: UIViewController {

    private let bluetoothPrinterManager = BluetoothPrinterManager()
    private let dummyPrinter = DummyPrinter()

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    @IBAction func tappedPrintButton(_ sender: Any) {
        
        
        let ticket = Ticket(
            .plainText("этот принтер работает")
        )
        
        if bluetoothPrinterManager.canPrint {
            bluetoothPrinterManager.print(ticket)
        }
        
        dummyPrinter.print(ticket)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? BluetoothPrinterSelectTableViewController {
            vc.sectionTitle = "Choose Bluetooth Printer"
            vc.printerManager = bluetoothPrinterManager
        }
    }
}
