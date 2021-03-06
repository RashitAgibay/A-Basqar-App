//
//  MenuViewController.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 10/31/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var cardView1: UIView!
    @IBOutlet weak var cardView2: UIView!
    @IBOutlet weak var cardView3: UIView!
    @IBOutlet weak var cardView4: UIView!
    @IBOutlet weak var cardView5: UIView!
    @IBOutlet weak var cardView6: UIView!
    @IBOutlet weak var cardView7: UIView!
    @IBOutlet weak var cardView8: UIView!
    @IBOutlet weak var cardView9: UIView!
    @IBOutlet weak var cardView10: UIView!
    
    
    
    
    override func viewDidLoad()
    {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        super.viewDidLoad()
        
        getAccessFuns()
        
        cardView1.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBuyProductsCard))
        cardView1.addGestureRecognizer(tapGesture)
        
        cardView2.isUserInteractionEnabled = true
        let tapGestureForMovement = UITapGestureRecognizer(target: self, action: #selector(tapMovementCard))
        cardView2.addGestureRecognizer(tapGestureForMovement)

        cardView3.isUserInteractionEnabled = true
        let tapGestureForSelling = UITapGestureRecognizer(target: self, action: #selector(tapSellingProductCard))
        cardView3.addGestureRecognizer(tapGestureForSelling)
        
        cardView4.isUserInteractionEnabled = true
        let tapGestureForIncomeCheck = UITapGestureRecognizer(target: self, action: #selector(tapIncomeKassaCard))
        cardView4.addGestureRecognizer(tapGestureForIncomeCheck)
        
        cardView5.isUserInteractionEnabled = true
        let tapGestureForBids = UITapGestureRecognizer(target: self, action: #selector(tapBidCard))
        cardView5.addGestureRecognizer(tapGestureForBids)
        
        cardView6.isUserInteractionEnabled = true
        let tapGestureForOutcomeCard = UITapGestureRecognizer(target: self, action: #selector(tapOutcomeKassaCard))
        cardView6.addGestureRecognizer(tapGestureForOutcomeCard)
        
        cardView7.isUserInteractionEnabled = true
        let tapGestureForManageCard = UITapGestureRecognizer(target: self, action: #selector(tapManageCard))
        cardView7.addGestureRecognizer(tapGestureForManageCard)
        
        cardView8.isUserInteractionEnabled = true
        let tapGestureForReportCard = UITapGestureRecognizer(target: self, action: #selector(tapReportCard))
        cardView8.addGestureRecognizer(tapGestureForReportCard)
        
        cardView9.isUserInteractionEnabled = true
        let tapGestureForProfileCard = UITapGestureRecognizer(target: self, action: #selector(tapProfileCard))
        cardView9.addGestureRecognizer(tapGestureForProfileCard)
        
//        cardView10.isUserInteractionEnabled = true
//        let tapGestureForAddingProductCard = UITapGestureRecognizer(target: self, action: #selector(tapAddProductCard))
//        cardView10.addGestureRecognizer(tapGestureForAddingProductCard)
        
        
        // MARK: - (2)
        var cardViews: Set<UIView> = []
        cardViews.insert(cardView1)
        cardViews.insert(cardView2)
        cardViews.insert(cardView3)
        cardViews.insert(cardView4)
        cardViews.insert(cardView5)
        cardViews.insert(cardView6)
        cardViews.insert(cardView7)
        cardViews.insert(cardView8)
        cardViews.insert(cardView9)
        
        
        
        
        var unusableCards: Set<UIView> = []
        
//        unusableCards.insert(cardView2)
        unusableCards.insert(cardView10)
        
        
        makeCardStandart(someCardViews: cardViews)
        makeUnsebleCardStandart(someCardViews: unusableCards)
        
    }
   
    
    
    
    
    // MARK: - (1)
   
    
    
    @objc func tapSellingProductCard(){
        performSegue(withIdentifier: "fromMainToMainExport", sender: self)
    }
    
    @objc func tapBuyProductsCard(){
        performSegue(withIdentifier: "fromMainToImport", sender: self)
    }
    
    @objc func tapIncomeKassaCard(){
        performSegue(withIdentifier: "fromMenuToImportKassa", sender: self)
    }
    
    @objc func tapOutcomeKassaCard(){
        performSegue(withIdentifier: "fromMenuToExportKassa", sender: self)
    }

    @objc func tapMovementCard(){
        performSegue(withIdentifier: "mainToMainMovement", sender: self)
    }
    
    @objc func tapBidCard(){
        performSegue(withIdentifier: "mainToMainBid", sender: self)
    }
    
    @objc func tapManageCard(){
        performSegue(withIdentifier: "mainToManage", sender: self)
    }
    
    @objc func tapReportCard(){
         // MARK: - (3) Card-ты басу арқылы профиль бетін ашу
         performSegue(withIdentifier: "fromMainToMainReport", sender: self)
    }
    
    @objc func tapProfileCard(){
         // MARK: - (3) Card-ты басу арқылы профиль бетін ашу
         performSegue(withIdentifier: "fromMainToProfile", sender: self)
    }
    
    @objc func tapAddProductCard(){
        // MARK: - (4) Card-ты басу арқылы Продуты қосатын бетін ашу
        performSegue(withIdentifier: "AddProductPage", sender: self)
    }
    
    func makeCardStandart(someCardViews: Set<UIView>){
        for someCardView in someCardViews {
            someCardView.layer.backgroundColor = UIColor.white.cgColor
            someCardView.layer.cornerRadius = 10
            someCardView.dropShadow()
        }
        
    }
    
    func makeUnsebleCardStandart(someCardViews: Set<UIView>){
        for someCardView in someCardViews {
            someCardView.layer.cornerRadius = 10
            someCardView.dropShadow()
        }
        
    }
    
    private func makeCardNonInteractable(view: UIView) {
        view.layer.backgroundColor = UIColor.lightGray.cgColor
        view.isUserInteractionEnabled = false
    }

    private func getAccessFuns() {
        ProfileNetworManager.service.getProfileInfo { (user, error) in
            ManagementNetworkManager.service.getUserAccessFuns(user: user?.id ?? 0) { (accesses, error) in
                self.setupAcceses(acesses: accesses ?? AccessFuncs())
            }
        }
    }
    
    private func setupAcceses(acesses: AccessFuncs){
        if acesses.importProduct == false {
            makeCardNonInteractable(view: cardView1)
        }
        if acesses.exportProduct == false {
            makeCardNonInteractable(view: cardView3)
        }
        if acesses.application == false {
            makeCardNonInteractable(view: cardView5)
        }
        if acesses.expense == false {
            makeCardNonInteractable(view: cardView6)
        }
        if acesses.income == false {
            makeCardNonInteractable(view: cardView4)
        }
        if acesses.management == false {
            makeCardNonInteractable(view: cardView7)
        }
        if acesses.movement == false {
            makeCardNonInteractable(view: cardView2)
        }
        if acesses.reports == false {
            makeCardNonInteractable(view: cardView8)
        }
    }
}




