//
//  ChangePasswordViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/1/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var oldPasswrordTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        
        
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
    

    
    func activateDelegateForTextField(oneTextField : UITextField){
        oneTextField.delegate = self
    }
    
    func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
        someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: someTextField.frame.height))
        someTextField.leftViewMode = UITextField.ViewMode.always
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
