//
//  AddNewSellerVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddNewSellerVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iinTextView: UITextField!
    @IBOutlet weak var phoneTextView: UITextField!
    @IBOutlet weak var nameOfCompanyTextView: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

         cardView.layer.backgroundColor = UIColor.white.cgColor
                          cardView.layer.cornerRadius = 5
                          cardView.dropShadow()
                   
                   addButton.layer.cornerRadius = 20
                   addButton.dropShadowforButton()
                   
                   activateDelegateForTextField(oneTextField: self.iinTextView)
                   activateDelegateForTextField(oneTextField: self.phoneTextView)
                   activateDelegateForTextField(oneTextField: self.nameOfCompanyTextView)
                   
                   freeSpaceOnLeftSideForTextFiedl(someTextField: iinTextView)
                   freeSpaceOnLeftSideForTextFiedl(someTextField: phoneTextView)
                   freeSpaceOnLeftSideForTextFiedl(someTextField: nameOfCompanyTextView)
    }
    

    
    @IBAction func addButton(_ sender: UIButton) {
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
