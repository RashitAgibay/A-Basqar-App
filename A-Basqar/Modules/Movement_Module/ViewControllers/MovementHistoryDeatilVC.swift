//
//  MovementHistoryDeatilVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class MovementHistoryDeatilVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate  {

    
    @IBOutlet weak var movementNameLabel: UILabel!
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "movementHistoryCell", for: indexPath)  as! MovementHistoryDetailCell
                
        return cell
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        navigateToMainMovement()
    }
    
    private func navigateToMainMovement() {
        performSegue(withIdentifier: "fromMHDtoMM", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromMHDtoMM" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MainMovementVC {
                destVC.selectedView = 1
            }
        }
        

    }

}
