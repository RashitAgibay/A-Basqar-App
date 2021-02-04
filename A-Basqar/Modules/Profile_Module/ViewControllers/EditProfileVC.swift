//
//  EditProfileVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 9/13/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class EditProfileVC: DefaultVC {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var saveDataButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    


    private func setupUI() {
        
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
    
    private func setupActions() {
        saveDataButton.addTarget(self, action: #selector(tapSaveButton), for: .touchUpInside)
    }
    
    @objc private func tapSaveButton() {
        saveData()
    }
    
    private func saveData() {
//        let edititngProfileModel = EditingProfileModel(fullname: fullNameTextField.text ?? "", username: nil, status: <#T##String#>)
//        ProfileNetworManager.service.editProfileData(editingProfileModel: <#T##EditingProfileModel#>, comletion: <#T##(CommonApiResponse?, Error?) -> ()#>)
    }
}
