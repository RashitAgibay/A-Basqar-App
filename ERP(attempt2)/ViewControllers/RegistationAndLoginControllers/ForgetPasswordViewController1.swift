//
//  ForgetPasswordViewController1.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 10/28/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class ForgetPasswordViewController1: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var phoneNmberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        sendButton.layer.cornerRadius = 20
        sendButton.dropShadowforButton()
        
        self.phoneNmberTextField.delegate = self

        freeSpaceOnLeftSideForTextFiedl(someTextField: phoneNmberTextField)
    }
    

    

    @IBAction func tappedSendButton(_ sender: Any) {
    }
    
    func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
        someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: someTextField.frame.height))
        someTextField.leftViewMode = UITextField.ViewMode.always
    }
}
