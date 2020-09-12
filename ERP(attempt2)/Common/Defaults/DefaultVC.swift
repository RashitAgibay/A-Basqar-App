//
//  DefaultVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/31/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class DefaultVC: UIViewController, UITextFieldDelegate {

    var reachability: Reachability?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
}

extension DefaultVC {
    
    func activateDelegateForTextField(oneTextField : UITextField){
         oneTextField.delegate = self
     }
    
    func showErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in
        
        }
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }
    
    func showErrorsAlertWithOneCancelButton(message: String) {
        
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
        
        }
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }
    
}
