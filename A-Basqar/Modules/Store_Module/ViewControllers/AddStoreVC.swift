//
//  AddStoreVC.swift
//  A-Basqar
//
//  Created by iliyas on 24.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class AddStoreVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    @IBAction func tapAddImageButton(_ sender: Any) {
    }
    @IBAction func tapSaveButton(_ sender: Any) {
        postNewStore(storeName: fullnameTextField.text ?? "")
    }
    @IBAction func tapBackButton(_ sender: Any) {
        self.navigateToStoreMain()
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
    
    private func postNewStore(storeName: String){
        ManagementNetworkManager.service.createNewStore(store: Store(name: storeName)) { (response, error) in
            if response?.status == "success" {
                self.navigateToStoreMain()
            }
        }
    }
    
    private func navigateToStoreMain() {
        performSegue(withIdentifier: "fromAStoMS", sender: self)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "fromAStoMS" {
//            if let navigationVC = segue.destination as? UINavigationController, let desVC = navigationVC.topViewController as? MainStoreVC {
//                desVC.selectedView = 1
//            }
//        }
//    }
}



