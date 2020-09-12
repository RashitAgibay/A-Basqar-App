//
//  EditProfileViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/1/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var saveDataButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
               cardView.layer.cornerRadius = 5
               cardView.dropShadow()
        
        saveDataButton.layer.cornerRadius = 20
        saveDataButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: self.fullNameTextField)
        activateDelegateForTextField(oneTextField: self.phoneNumberTextField)
        activateDelegateForTextField(oneTextField: self.businessNameTextField)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: fullNameTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: phoneNumberTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: businessNameTextField)
        
        
        
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

