//
//  BidHistoryDetailVC.swift
//  A-Basqar
//
//  Created by iliyas on 22.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class BidHistoryDetailVC: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate  {

    @IBOutlet weak var bidNameLabel: UILabel!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var senderPlaceNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "movementHistoryCell", for: indexPath)  as! MovementHistoryDetailCell
                
        return cell
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        navigateToMainBid()
    }

    private func navigateToMainBid() {
        performSegue(withIdentifier: "fromBHDtoMB", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromBHDtoMB" {
            if let navigationVC = segue.destination as? UINavigationController,
                let destVC = navigationVC.topViewController as? MainBidVC {
                destVC.selectedView = 2
            }
        }
        

    }
    
    private func setupUI() {
        

    }
}
