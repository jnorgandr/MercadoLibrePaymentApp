//
//  PagoViewController.swift
//  PaymentApp
//
//  Created by minti on 12/29/18.
//  Copyright © 2018 studiominti. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

let apiPaymentURL = "https://api.mercadopago.com/v1/payment_methods?public_key=444a9ef5-8a6b-429f-abdf-587639155d88"

class PagoViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    

    @IBOutlet weak var montoLabel: UITextField!
    @IBOutlet weak var medioDePagoPickerView: UIPickerView!
    
    var mediosDePago: [MedioDePago] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPaymentMethods()
        montoLabel.delegate = self
        medioDePagoPickerView.delegate = self
        medioDePagoPickerView.dataSource = self

        // Do any additional setup after loading the view.
        
        //View BackGround Color
        view.setGradientBackground(colorOne: Colors.darkYellow, colorTwo: Colors.white)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if CompraSingleton.shared.buyFinished == true {
            Alert.buyFinishedAlert(on: self)
        }
    }
    
    @IBAction func montoChanged(_ sender: Any) {
        
        CompraSingleton.shared.amount = Int(self.montoLabel.text!)!
    }
    
    @IBAction func nextViewButton(_ sender: Any) {
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        montoLabel.resignFirstResponder()
        return true
    }
    
    // MARK: - PickerView Protocol methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mediosDePago.count
    }

    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return mediosDePago[row].paymentName
    }
    */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CompraSingleton.shared.bankName = mediosDePago[row].bankName
        CompraSingleton.shared.paymentId = mediosDePago[row].paymentId
        CompraSingleton.shared.cardName = mediosDePago[row].paymentName
    
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }

    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(0, 0, pickerView.bounds.width - 30, 40))
        
        let myImageView = UIImageView(frame: CGRect(90, 0, 30, 30))
        
        let urlImage = mediosDePago[row].imageURL
        
        Alamofire.request(urlImage).responseImage { response in
            
            if let image = response.result.value {
                myImageView.image = image
            }
            
        }
        let myLabel = UILabel(frame: CGRect(160, 0, pickerView.bounds.width - 90, 40))
        myLabel.text = mediosDePago[row].paymentName
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
        
    }
    
    // MARK: -  Update Medios de Pago
    
    func updateMediosDePago() {
        
        for _ in mediosDePago {
            /*
             print("Tarjeta:\(medio.paymentName), (medio.imagenURL)")
             */
            
            self.medioDePagoPickerView.reloadAllComponents()
            CompraSingleton.shared.cardName = mediosDePago[0].paymentName
            CompraSingleton.shared.paymentId = mediosDePago[0].paymentId
            
    }

}
    // MARK: -  Get Payment Methods
    
    func getPaymentMethods() {
        
        Alamofire.request(apiPaymentURL).responseJSON { response in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
                
                if let dataFromString = utf8Text.data(using: .utf8, allowLossyConversion: false) {
                    let json = try! JSON(data: dataFromString)
                    let mercadoLibreArray = json.array
                    // If json is .Dictionary
                    var index = 0
                    for _ in mercadoLibreArray! {
                        
                        let medioDePago :MedioDePago = MedioDePago()
                        
                        for (key,values):(String, JSON) in mercadoLibreArray![index] {
                            
                            if key == "name"{
                                //print("data1: \(subJson)")
                                medioDePago.paymentName = values.stringValue
                            }
                            
                            if key == "id"{
                                //print("data1: \(subJson)")
                                medioDePago.paymentId = values.stringValue
                            }
                            
                            if key == "secure_thumbnail"{
                                //print("data2: \(subJson)")
                                medioDePago.imageURL = values.stringValue
                            }
                            
                        }
                        
                        self.mediosDePago.append(medioDePago)
                        
                        index += 1
                    }
                    
                    self.updateMediosDePago()
                }
                
            }
        }
        

 }
    
}

extension CGRect {
    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
        self.init(x:x, y:y, width:w, height:h)
    }
}
