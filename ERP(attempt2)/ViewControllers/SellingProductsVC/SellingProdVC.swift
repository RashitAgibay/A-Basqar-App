//
//  SellingProdVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 12/5/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class SellingProdVC: UIViewController {

    @IBOutlet weak var homeBarButton: UIBarButtonItem!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var firstPageView: UIView!
    @IBOutlet weak var secondPageView: UIView!
    
    var companyNameBuyProductVC: String = "Покупатель..."
    var company_id: Int = 0
    var goodsAmountFromGoodsList: Int = 0
    var sellingProdsFirstPage: SelleingProdsFirstPageVC!
    
    var selected_segment_sender: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        segmentView.removeBorder()
        segmentView.addUnderlineForSelectedSegment()
        
        
        if selected_segment_sender == 1 {
            segmentView.selectedSegmentIndex = 1
            firstPageView.alpha = 1
            secondPageView.alpha = 0
        }
        
//        print("here is a goodsAmountFromGoodsList \(goodsAmountFromGoodsList)")
        
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Компаниялар тізімінен біреуінің атын сату корзинасына жіберу үшін
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let vc = segue.destination as? SelleingProdsFirstPageVC,
            segue.identifier == "tothesellerbasket" {
            self.sellingProdsFirstPage = vc
            self.sellingProdsFirstPage.companyNameFromList = companyNameBuyProductVC
            self.sellingProdsFirstPage.companyIdFromList = company_id
        
        }
    }

   
    @IBAction func switchPages(_ sender: UISegmentedControl) {
        
        segmentView.changeUnderlinePosition()
               
               switch sender.selectedSegmentIndex {
               case 0:
                   firstPageView.alpha  = 0
                   secondPageView.alpha = 1
                   break
                   
               case 1:
                   firstPageView.alpha = 1
                   secondPageView.alpha = 0
               default:
                   break
               }
        
    }
    
    public func hexStringToUIColor (hex:String) -> UIColor {
          var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

          if (cString.hasPrefix("#")) {
              cString.remove(at: cString.startIndex)
          }

          if ((cString.count) != 6) {
              return UIColor.gray
          }

          var rgbValue:UInt64 = 0
          Scanner(string: cString).scanHexInt64(&rgbValue)

          return UIColor(
              red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: CGFloat(1.0)
          )
      }

}

