//
//  NewMovementInBidVC.swift
//  A-Basqar
//
//  Created by iliyas on 21.04.2020.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit

class NewMovementInBidVC: UIViewController,  UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var movementNameLabel: UILabel!
    @IBOutlet weak var receiverNameLabel: UILabel!
    @IBOutlet weak var receiverPlaceNameLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "newMovementBidCell", for: indexPath)  as! NewMovementInBidCell
                
        return cell
    }
    
    @IBAction func tapBackButton(_ sender: Any) {
        
        navigateBack()
    }
    
    @IBAction func tapAcceptButton(_ sender: Any) {
        
    }
    
    @IBAction func tapDeclineButton(_ sender: Any) {
        
    }
    
    private func navigateBack() {
        performSegue(withIdentifier: "fromNMBtoCBD", sender: self)
    }
    
    private func setupUI() {
        
        acceptButton.layer.cornerRadius = 20
        acceptButton.dropShadowforButton()
        
        declineButton.layer.cornerRadius = 20
        declineButton.dropShadowforButton()
    }

}
