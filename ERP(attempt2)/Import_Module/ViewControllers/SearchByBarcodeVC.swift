//
//  SearchByBarcodeVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 8/16/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import AVFoundation


//MARK: - barcode, штрих код оқу жасап тұр осы клас ішінде
class SearchByBarcodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {

    
    @IBOutlet weak var videoView: UIView!
    
    var goodListArray = NSArray()
    
    var string = String()
    var goodID = Int()
    
    enum error: Error {
           case noCamereAvailable
           case videoInputInitFail
       }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        do {
            
            try scanQrCode()
        }
        catch {
            print("failed to scan qr/barcode")
        }
    }
    
    

    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        
        if metadataObjects.count > 0 {
            let machineReadableCode = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
            if machineReadableCode.type == AVMetadataObject.ObjectType.code128 {
                string = machineReadableCode.stringValue!
    //                print("here is a I can make performsegue")
//                print("here is a var code result: \(string)")
                
//                testForApi()
                connection.isEnabled = false // MARK: - код бір ақ рет шығару үшін
                getGoodByBarCode()
                performSegue(withIdentifier: "frombarcodetoimport", sender: self)
                
                }
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                string = machineReadableCode.stringValue!
                //                print("here is a I can make performsegue")
//                print("here is a var code result: \(string)")
                
//                testForApi()
                connection.isEnabled = false // MARK: - код бір ақ рет шығару үшін
                getGoodByBarCode()
                performSegue(withIdentifier: "frombarcodetoimport", sender: self)
            }
        }
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//          if segue.identifier == "frombarcodetoimport" {
//              if let destVC = segue.destination as? UINavigationController,
//                  let targetController = destVC.topViewController as? BuyProductVC {
//                  targetController.barcode = string
//              }
//          }
//      }
    
    
    
   func scanQrCode() throws {
        let avCaptureSession = AVCaptureSession()
        
        guard let avCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            print("no camera")
            throw error.noCamereAvailable
        }
        
        guard let avCaptureInput  = try? AVCaptureDeviceInput(device: avCaptureDevice) else {
            print("failed to inint camera")
            throw error.videoInputInitFail
        }
        
        let avCaptureMetadataOutput = AVCaptureMetadataOutput()
        
        avCaptureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        avCaptureSession.addInput(avCaptureInput)
        avCaptureSession.addOutput(avCaptureMetadataOutput)
        
        avCaptureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.code128, AVMetadataObject.ObjectType.qr]
        
        let avCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer(session: avCaptureSession)
        
        avCaptureVideoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCaptureVideoPreviewLayer.frame = videoView.bounds
        
        self.videoView.layer.addSublayer(avCaptureVideoPreviewLayer)
        
        avCaptureSession.startRunning()
        
       
        
    }
    
    
    func getGoodByBarCode() {
        
        do {
            reacibility = try Reachability.init()
        }
        
        catch {
        
        }
        
        if ((reacibility!.connection) != .unavailable){
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String

            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]

            
            let encodeURL = productListUrl

            let requestOfApi = AF.request(encodeURL + "?code=\(string)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request)
//                print(response.result)
//                print(response.response)
                
                switch response.result {
                
                case .success(let payload):
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    if let x = payload as? Dictionary<String,AnyObject> {
                        
//                        print(x)
                        
                        let resultValue = x["results"] as! NSArray
                        
                        self.goodListArray = NSMutableArray(array: resultValue)
                        
                        let good = self.goodListArray[0] as! NSDictionary
                        self.goodID = good["id"] as! Int
                        
                        self.SendGoodToBasketApi()
                        
                    }
                    else {
                        
                        let resultValue = payload as! NSArray
                        self.goodListArray = NSMutableArray(array: resultValue)
                        
                        let good = self.goodListArray[0] as! NSDictionary
                        self.goodID = good["id"] as! Int
                        
                        self.SendGoodToBasketApi()
                        
//                        debug_print(message: "here is a goodListArray", object: self.goodID)
                    }
                case .failure(let error):
                    
                    print(error)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")}
            })
        
        }
        
        else {
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    
    func SendGoodToBasketApi() {
        do {
            reacibility = try Reachability.init()
        }
        catch {
            print("unable to start notifier")
        }
        
        if ((reacibility!.connection) != .none){
            
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let token = UserDefaults.standard.string(forKey: userTokenKey) as! String

            let headers: HTTPHeaders = [
                
                "Content-Type": "application/json".trimmingCharacters(in: .whitespacesAndNewlines),
                "Authorization":"JWT \(token)".trimmingCharacters(in: .whitespacesAndNewlines),
            ]
            
            let params = [
                
                "goods":"\(self.goodID)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
                "nums":"\(1)".trimmingCharacters(in: .whitespacesAndNewlines) as AnyObject,
            ]
            
            
            let encodeURL = importShoppingCartURL

            let requestOfApi = AF.request(encodeURL, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil)
            requestOfApi.responseJSON(completionHandler: {(response)-> Void in
                
//                print(response.request!)
//                print(response.result)
//                print(response.response)
            })
        
        }
        
        else {
            print("internet is not working")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.ShowErrorsAlertWithOneCancelButton(message: "Проверьте соединение с интернетом")
        }
    }
    
    func ShowErrorsAlertWithOneCancelButton(title: String, message: String, buttomMessage: String) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttomMessage, style: .cancel) { (action) in
        }
        
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }
    
    func ShowErrorsAlertWithOneCancelButton(message: String) {
        
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .cancel) { (action) in
        }
        alertController.addAction(action)
        self.present(alertController,animated: true, completion: nil)
    }

}
