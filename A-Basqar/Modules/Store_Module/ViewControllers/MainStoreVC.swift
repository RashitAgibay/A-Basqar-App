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
    
    @IBAction func tapAddButton(_ sender: Any) {
        
        self.showAlerWithThreeButtons(title: "Выберите действие", storeButton: "Добавить новый склад/магазин", employeeButton: "Добавить новый персонал" )
        
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
    
    private func navigateToAddStore() {
        performSegue(withIdentifier: "fromMStoAS", sender: self)
    }
    
    private func navigateToAddEmployee() {
        performSegue(withIdentifier: "fromMStoAE", sender: self)
    }

    func showAlerWithThreeButtons(title: String, message: String = "", storeButton: String, employeeButton: String, cancelButton: String = "Отмена") {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let addStoreAction = UIAlertAction(title: storeButton, style: .default) { (alert) in
            self.navigateToAddStore()
        }
        let addEmployeeAction = UIAlertAction(title: employeeButton, style: .default) { (alert) in
            self.navigateToAddEmployee()
        }
        let cancelAction = UIAlertAction(title: cancelButton, style: .cancel) { (action) in}
        alertController.addAction(addStoreAction)
        alertController.addAction(addEmployeeAction)
        alertController.addAction(cancelAction)
        self.present(alertController,animated: true, completion: nil)
    }
}
