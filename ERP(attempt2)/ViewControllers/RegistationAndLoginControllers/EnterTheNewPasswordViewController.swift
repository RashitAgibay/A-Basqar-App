//
//  EnterTheNewPasswordViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 10/29/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class EnterTheNewPasswordViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var resetPasswordButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()


        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 

        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
    
        resetPasswordButton.layer.cornerRadius = 20
        resetPasswordButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: newPasswordTextField)
        activateDelegateForTextField(oneTextField: rePasswordTextField)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: newPasswordTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: rePasswordTextField)
        
        
        
        
    }
    

    
    @IBAction func tappedResetPasswordButton(_ sender: Any) {
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
