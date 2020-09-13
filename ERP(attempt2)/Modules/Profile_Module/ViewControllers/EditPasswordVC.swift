//
//  EditPasswordVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 9/13/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class EditPasswordVC: DefaultVC {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var oldPasswrordTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    

    private func setupUI() {
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        changePasswordButton.layer.cornerRadius = 20
        changePasswordButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: self.oldPasswrordTextField)
        activateDelegateForTextField(oneTextField: self.newPassTextField)
        activateDelegateForTextField(oneTextField: self.rePasswordTextField)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: oldPasswrordTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: newPassTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: rePasswordTextField)
    }

}
