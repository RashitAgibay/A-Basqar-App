//
//  UpdateContrInfoExportVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/1/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class UpdateContrInfoExportVC: DefaultVC {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var contrNameTextField: UITextField!
    @IBOutlet weak var contrPhoneTextField: UITextField!
    @IBOutlet weak var contrBinTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    

    private func setupUI() {
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        updateButton.layer.cornerRadius = 20
        updateButton.dropShadowforButton()
        
        contrNameTextField.delegate = self
        contrPhoneTextField.delegate = self
        contrBinTextField.delegate = self
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrNameTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrPhoneTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: contrBinTextField)
    }


}
