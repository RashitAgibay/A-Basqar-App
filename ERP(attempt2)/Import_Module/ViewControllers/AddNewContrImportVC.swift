//
//  AddNewContrImportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/4/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddNewContrImportVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contrNameTextField: UITextField!
    @IBOutlet weak var contrPhoneTextField: UITextField!
    @IBOutlet weak var contrBinTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    @IBAction func tappedAddButton(_ sender: Any) {
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

}
