//
//  EditEmployeeDataVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class EditEmployeeDataVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var replyPasswordTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        self.navigateBack()
    }
    
    private func navigateBack() {
        performSegue(withIdentifier: "fromEEDtoMS", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromEEDtoMS" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MainStoreVC {
                destVC.selectedView = 1
            }
        }
    }
    
    private func setupUI() {
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        activateDelegateForTextField(oneTextField: self.fullNameTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: fullNameTextField)
        
        activateDelegateForTextField(oneTextField: self.phoneTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: phoneTextField)
        
        activateDelegateForTextField(oneTextField: self.passwordTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: passwordTextField)
        
        activateDelegateForTextField(oneTextField: self.replyPasswordTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: replyPasswordTextField)
        
        saveButton.layer.cornerRadius = 25
        saveButton.dropShadowforButton()
    }

    func activateDelegateForTextField(oneTextField : UITextField){
        oneTextField.delegate = self
    }

    func freeSpaceOnLeftSideForTextFiedl(someTextField : UITextField){
        someTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 17, height: someTextField.frame.height))
        someTextField.leftViewMode = UITextField.ViewMode.always
    }


}
