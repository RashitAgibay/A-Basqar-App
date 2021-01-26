//
//  EmployeeeFuncs.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class EmployeeeFuncs: UIViewController {

    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var cardView: UIView!
    
    @IBOutlet weak var buyingSwitch: UISwitch!
    @IBOutlet weak var movingSwitch: UISwitch!
    @IBOutlet weak var sellingSwitch: UISwitch!
    @IBOutlet weak var kassaIncomeSwitch: UISwitch!
    @IBOutlet weak var kassaOutcomeSwitch: UISwitch!
    @IBOutlet weak var bidsSwitch: UISwitch!
    @IBOutlet weak var reportsSwitch: UISwitch!
    @IBOutlet weak var managementSwitch: UISwitch!
    @IBOutlet weak var profileSwitch: UISwitch!
    @IBOutlet weak var addProductsSwitch: UISwitch!
    
    @IBOutlet weak var selectStoreButton: UIButton!
    @IBOutlet weak var selecDutyButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    

    @IBAction func tappBackButton(_ sender: Any) {
        
        self.navigateToMainStore()
    }
    
    
    private func navigateToMainStore() {
        performSegue(withIdentifier: "fromEFtoMS", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromEFtoMS" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MainStoreVC {
                destVC.selectedView = 1
            }
        }
    }
    
    private func setupUI() {
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        selecDutyButton.layer.cornerRadius = 5
        selecDutyButton.dropShadowforButton()
        selectStoreButton.layer.cornerRadius = 5
        selectStoreButton.dropShadowforButton()
        
        saveButton.layer.cornerRadius = 25
        saveButton.dropShadowforButton()
    }

}
