//
//  EditPasswordVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 9/13/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class EditPasswordVC: DefaultVC {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var oldPasswrordTextField: UITextField!
    @IBOutlet weak var newPassTextField: UITextField!
    @IBOutlet weak var rePasswordTextField: UITextField!
    @IBOutlet weak var changePasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    

    private func setupUI() {
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
    
    private func setupActions() {
        changePasswordButton.addTarget(self, action: #selector(tapChangeButton), for: .touchUpInside)
    }
    
    @objc private func tapChangeButton() {
        if newPassTextField.text == "" || oldPasswrordTextField.text == "" || rePasswordTextField.text == "" {
            showSimpleAlert(title: "Ошибка", message: "Все поля должны быть заполнены")
        }
        else {
            changePassword()
        }
    }
    
    private func changePassword() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        if checkEnteredPasswords(first: newPassTextField.text ?? "", second: rePasswordTextField.text ?? "") == true {
            MBProgressHUD.hide(for: self.view, animated: true)
            let editingPasswordModel = EditingPasswordModel(oldPassword: oldPasswrordTextField.text ?? "", newPassword: newPassTextField.text ?? "")
            print("/// editingPasswordModel:", editingPasswordModel)
            ProfileNetworManager.service.editPassword(editingPasswordModel: editingPasswordModel) { (message, error) in
                if message?.response != nil {
                    self.showSimpleAlert(message: "Пароль успешно изменен")
//                    self.dismiss(animated: true, completion: nil)
                }
                if error != nil {
                    self.showSimpleAlert(title: "Ошибка", message: "Ошибка в api")
                }
            }
        }
        else {
            self.showSimpleAlert(title: "Ошибка", message: "Введенные пароли не совпадают")
        }

    }
    
    private func checkEnteredPasswords(first: String, second: String) -> Bool {
        if first == second {
            return true
        }
        else {
            return false
        }
    }
}

