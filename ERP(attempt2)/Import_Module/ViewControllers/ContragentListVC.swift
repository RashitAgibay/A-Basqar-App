//
//  ContragentListVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 7/4/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class ContragentListVC: UIViewController {

    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    



}


extension ContragentListVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "contragentListCell", for: indexPath)
        
        return cell
    }
    
    
    
}

extension ContragentListVC: ContragentListCellDelegate {
    
    func updateContragent(cell: ContragentListCell, id: Int) {
        
        self.navigateToUpdateContrInfo()
    }
    
}

extension ContragentListVC {
    
    private func navigateToUpdateContrInfo() {
        
        performSegue(withIdentifier: "fromContrListToUpdateContr", sender: self)
    }
}
