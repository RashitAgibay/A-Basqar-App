//
//  AddNewContrImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/4/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import Alamofire


class AddNewContrImportVC: DefaultVC {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contrNameTextField: UITextField!
    @IBOutlet weak var contrPhoneTextField: UITextField!
    @IBOutlet weak var contrBinTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigateToContrList()
    }
    

    @IBAction func tappedAddButton(_ sender: Any) {
        if contrNameTextField.text == "" {
            self.showErrorsAlertWithOneCancelButton(message: "Название не может быть пустым")
        }
        
        else {
            createNewContr(name: contrNameTextField.text!, bin: contrBinTextField.text ?? "", phone: contrPhoneTextField.text ?? "")
        }
        
    }
    
    private func setupUI() {
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        addButton.layer.cornerRadius = 20
        addButton.dropShadowforButton()
        
        contrNameTextField.delegate = self
        contrPhoneTextField.delegate = self
        contrBinTextField.delegate = self
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrNameTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrPhoneTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrBinTextField)
    }
    
    private func createNewContr(name: String, bin: String?, phone: String?) {
        var contr = ContrSending()
        if name != "" {
            contr.name = name
        }
        if bin != "" {
            contr.bin = bin
        }
        if phone != "" {
            contr.phoneNumber = phone
        }
        
        ManagementNetworkManager.service.createNewContr(contr: contr) { (message, error) in
            if message?.message == "success" {
                self.navigateToContrList()
            }
        }
    }

}

extension AddNewContrImportVC {
    private func navigateToContrList() {
        performSegue(withIdentifier: "fromAddNewContrToContrList", sender: self)
    }
}


