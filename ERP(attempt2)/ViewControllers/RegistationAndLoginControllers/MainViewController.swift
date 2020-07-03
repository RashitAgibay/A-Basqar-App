//
//  MainViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 10/25/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var adressTextField: UITextField!
    @IBOutlet weak var businessTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 

        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        signUpButton.layer.cornerRadius = 20
        signUpButton.dropShadowforButton()
        
        
//        self.nameTextField.delegate = self
//        self.phoneNumberTextField.delegate = self
//        self.passwordTextField.delegate = self
//        self.rePasswordTextField.delegate = self
//        self.adressTextField.delegate = self
//        self.businessTextField.delegate = self
//        self.mailTextField.delegate = self
        activateDelegateForTextField(oneTextField: self.nameTextField)
        activateDelegateForTextField(oneTextField: self.phoneNumberTextField)
        activateDelegateForTextField(oneTextField: self.passwordTextField)
        activateDelegateForTextField(oneTextField: self.rePasswordTextField)
        activateDelegateForTextField(oneTextField: self.adressTextField)
        activateDelegateForTextField(oneTextField: self.businessTextField)
        activateDelegateForTextField(oneTextField: self.mailTextField)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: nameTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: phoneNumberTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: passwordTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: rePasswordTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: adressTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: businessTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: mailTextField)

        
        
    }
    

   
    
    
    @IBAction func clickSignUpButton(_ sender: Any) {
    }
    
    
    @IBAction func clickSignInButton(_ sender: Any) {
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




