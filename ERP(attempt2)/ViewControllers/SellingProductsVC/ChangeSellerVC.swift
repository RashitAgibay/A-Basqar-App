//
//  ChangeSellerVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class ChangeSellerVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iinTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var companyNameTexField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        cardView.layer.backgroundColor = UIColor.white.cgColor
               cardView.layer.cornerRadius = 5
               cardView.dropShadow()
        
        changeButton.layer.cornerRadius = 20
        changeButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: self.iinTextField)
        activateDelegateForTextField(oneTextField: self.phoneTextField)
        activateDelegateForTextField(oneTextField: self.companyNameTexField)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: iinTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: phoneTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: companyNameTexField)
    }
    

   

    @IBAction func tapChangeButton(_ sender: Any) {
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
