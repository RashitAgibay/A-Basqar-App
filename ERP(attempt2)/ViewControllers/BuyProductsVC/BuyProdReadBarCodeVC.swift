//
//  BuyProdReadBarCodeVC.swift
//  A-Basqar
//
//  Created by Ilyas Shomat on 1/29/20.
//  Copyright © 2020 Ilyas Shomat. All rights reserved.
//

import UIKit
import AVFoundation



//MARK: - barcode, штрих код оқу жасап тұр осы клас ішінде
class BuyProdReadBarCodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate  {

    
    @IBOutlet weak var videoView: UIView!
    
    
    var string = String()
    
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
                
                testForApi()
                connection.isEnabled = false
                performSegue(withIdentifier: "frombarcodetoimport", sender: self)
                
                }
            if machineReadableCode.type == AVMetadataObject.ObjectType.qr {
                string = machineReadableCode.stringValue!
                //                print("here is a I can make performsegue")
//                print("here is a var code result: \(string)")
                
                testForApi()
                connection.isEnabled = false // MARK: - код бір ақ рет шығару үшін
                performSegue(withIdentifier: "frombarcodetoimport", sender: self)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "frombarcodetoimport" {
              if let destVC = segue.destination as? UINavigationController,
                  let targetController = destVC.topViewController as? BuyProductVC {
                  targetController.barcode = string
              }
          }
      }
    
    func testForApi(){
        debug_print(message: "it is a barcode: ", object: string)
    }
    
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

}
