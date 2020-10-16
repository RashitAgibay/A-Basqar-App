//
//  EditStoreVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class EditStoreVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

    }
    

    @IBAction func tapAddImageButton(_ sender: Any) {
    }
    
    @IBAction func tapSaveButton(_ sender: Any) {
    }

    private func setupUI() {
        
        cardView.layer.backgroundColor = UIColor.white.cgColor
        cardView.layer.cornerRadius = 5
        cardView.dropShadow()
        
        activateDelegateForTextField(oneTextField: self.fullnameTextField)
        freeSpaceOnLeftSideForTextFiedl(someTextField: fullnameTextField)
        
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
