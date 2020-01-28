//
//  4DigitsCodePagesViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 10/29/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class _DigitsCodePagesViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var firstDigitTextField: UITextField!
    @IBOutlet weak var secondDigitTextField: UITextField!
    @IBOutlet weak var thirdDigitTextField: UITextField!
    @IBOutlet weak var fourthDigitTextField: UITextField!
    @IBOutlet weak var remakePaswwordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
               cardView.layer.cornerRadius = 5
               cardView.dropShadow()
        
        remakePaswwordButton.layer.cornerRadius = 20
        remakePaswwordButton.dropShadowforButton()
        
        activateDelegateForTextField(oneTextField: firstDigitTextField)
        activateDelegateForTextField(oneTextField: secondDigitTextField)
        activateDelegateForTextField(oneTextField: thirdDigitTextField)
        activateDelegateForTextField(oneTextField: fourthDigitTextField)
        
        freeSpaceOnLeftSideForTextFiedl(someTextField: firstDigitTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: secondDigitTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: thirdDigitTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: fourthDigitTextField)
        

        
    }
    

  
    @IBAction func tappedRemakePasswordButton(_ sender: Any) {
    }
    
    func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
          someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: someTextField.frame.height))
          someTextField.leftViewMode = UITextField.ViewMode.always
    
      }
    
    func activateDelegateForTextField(oneTextField : UITextField){
        oneTextField.delegate = self
    }
}
