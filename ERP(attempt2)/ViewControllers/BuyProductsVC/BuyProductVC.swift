//
//  BuyProductVC.swift
//  ERP(attempt2)
//
//  Created by Ilyas Shomat on 11/26/19.
//  Copyright © 2019 Ilyas Shomat. All rights reserved.
//

import UIKit

class BuyProductVC: UIViewController {

    @IBOutlet weak var firstPageView: UIView!
    @IBOutlet weak var secondViewPage: UIView!
    
    
    @IBOutlet weak var segmentView: UISegmentedControl!

    
    var companyNameBuyProductVC: String = "Контрагент..."
    var companyNameIdBuyProductVC: Int = 0
    var goodPriceInBuscket: String = "goodPriceInBuscket"
    var buyProductFirstPage: BuyProductVCFirstPage!
    var selectedSegmentId: Int = 0
    var barcode = String()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
        // MARK: - (id123)
    
    
//        print("barcode in the BuyProductVC: \(barcode)")
        
//        print("here is a \(selectedSegmentId)")
        
        segmentView.addUnderlineForSelectedSegment()
        segmentView.changeUnderlinePosition()
//        print("\(companyNameBuyProductVC) in BuyProductVC")
//        print("\(goodPriceInBuscket) in BuyProductVC ")
//        print("here is a company id \(companyNameIdBuyProductVC)")
        
        //MARK: - Тарих истриясынан арқа шегінгенде тарих беті шығып тұру үшін
        if selectedSegmentId == 1 {
            segmentView.selectedSegmentIndex = 1
            firstPageView.alpha = 1
            secondViewPage.alpha = 0
        }
        
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {


        if let vc = segue.destination as? BuyProductVCFirstPage,
            segue.identifier == "tothechildview" {
            self.buyProductFirstPage = vc
            // if you already have your data object
            self.buyProductFirstPage.companyNameFromList = companyNameBuyProductVC
            self.buyProductFirstPage.companyIdFromList = companyNameIdBuyProductVC
            self.buyProductFirstPage.barcode_from_main = barcode
            
        }

    }
  
    @IBAction func switchSegmentAction(_ sender: UISegmentedControl) {
        
        // MARK: - (id123)
        segmentView.changeUnderlinePosition()
        
    
        
        
        switch sender.selectedSegmentIndex {
        case 0:
            firstPageView.alpha  = 0
            secondViewPage.alpha = 1
            break
            
        case 1:
            firstPageView.alpha = 1
            secondViewPage.alpha = 0
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


extension UISegmentedControl {
    func removeBorder(){
        let backgroundImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: self.bounds.size)
        self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
        self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

        let deviderImage = UIImage.getColoredRectImageWith(color: UIColor.white.cgColor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
        self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)], for: .selected)
    }

    func addUnderlineForSelectedSegment(){
        removeBorder()
        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor(red: 67/255, green: 129/255, blue: 244/255, alpha: 1.0)
        underline.tag = 1
        self.addSubview(underline)
    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        UIView.animate(withDuration: 0.1, animations: {
            underline.frame.origin.x = underlineFinalXPosition
        })
    }
}

extension UIImage {

    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage!
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
