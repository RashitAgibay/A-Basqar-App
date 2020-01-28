//
//  ChangeBuyerVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/2/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class ChangeBuyerVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var iinTextView: UITextField!
    @IBOutlet weak var phoneTextView: UITextField!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
               cardView.layer.cornerRadius = 5
               cardView.dropShadow()
        
        changeButton.layer.cornerRadius = 20
        changeButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: self.iinTextView)
        activateDelegateForTextField(oneTextField: self.phoneTextView)
        activateDelegateForTextField(oneTextField: self.nameTextView)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: iinTextView)
        freeSpaceOnLeftSideForTextFiedl(someTextField: phoneTextView)
        freeSpaceOnLeftSideForTextFiedl(someTextField: nameTextView)
    }
    

    

    @IBAction func tappedChangeButton(_ sender: Any) {
    }
    
    @IBAction func tappedAddBuyerButton(_ sender: Any) {
           print("tapped btn")
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
