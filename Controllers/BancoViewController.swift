//
//  BancoViewController.swift
//  PaymentApp
//
//  Created by minti on 12/31/18.
//  Copyright © 2018 studiominti. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

let apiBanksSource = "https://api.mercadopago.com/v1/payment_methods/card_issuers?public_key=444a9ef5-8a6b-429f-abdf-587639155d88&payment_method_id=visa"

class BancoViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Considering previous choice
    var apiBanksURL = apiBanksSource + "&payment_method_id=" + CompraSingleton.shared.paymentId
    
    @IBOutlet weak var banksPickerView: UIPickerView!
    
    
    var mediosBancarios: [MedioBancario] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getBanksMethods()
        banksPickerView.delegate = self
        banksPickerView.dataSource = self
        
        // Do any additional setup after loading the view.
        
        //View BackGround Color
        view.setGradientBackground(colorOne: Colors.darkYellow, colorTwo: Colors.white)
    }
    
    
    // MARK: - PickerView Protocol methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return mediosBancarios.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CompraSingleton.shared.bankName = mediosBancarios[row].bankName
        CompraSingleton.shared.issuerId = mediosBancarios[row].issuerId
    }
    
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(0, 0, pickerView.bounds.width - 30, 40))
        
        let myImageView = UIImageView(frame: CGRect(90, 0, 30, 30))
        
        let urlImage = mediosBancarios[row].imageURL
        
        Alamofire.request(urlImage).responseImage { response in
            
            if let image = response.result.value {
                myImageView.image = image
            }
            
        }
        
        let myLabel = UILabel(frame: CGRect(160, 0, pickerView.bounds.width - 90, 40))
        myLabel.text = mediosBancarios[row].bankName
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
        
    }
    
    
    // MARK: -  Update Medios de Pago
    
    func updateMediosDePago() {
        
        for _ in mediosBancarios {
            /*
             print("Banco:\(medio.bankName) , Imagen:\(medio.imagenURL)")
             */
            
            self.banksPickerView.reloadAllComponents()
            CompraSingleton.shared.issuerId = mediosBancarios[0].issuerId
            CompraSingleton.shared.bankName = mediosBancarios[0].bankName
            
        }
        
    }
    
    // MARK: -  Get Banks Methods
    
    func getBanksMethods() {
        
        Alamofire.request(apiBanksURL).responseJSON { response in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
                
                if let dataFromString = utf8Text.data(using: .utf8, allowLossyConversion: false) {
                    let json = try! JSON(data: dataFromString)
                    let mercadoLibreArray = json.array
                    // If json is .Dictionary
                    var index = 0
                    for _ in mercadoLibreArray! {
                        
                        let medioBancario :MedioBancario = MedioBancario()
                        
                        for (key,values):(String, JSON) in mercadoLibreArray![index] {
                            
                            if key == "name"{
                                //print("data1: \(subJson)")
                                medioBancario.bankName = values.stringValue
                            }
                            
                            if key == "id"{
                                //print("data1: \(subJson)")
                                medioBancario.issuerId = values.stringValue
                            }
                            
                            if key == "secure_thumbnail"{
                                //print("data2: \(subJson)")
                                medioBancario.imageURL = values.stringValue
                            }
                            
                        }
                        
                        self.mediosBancarios.append(medioBancario)
                        
                        index += 1
                    }
                    
                    self.updateMediosDePago()
                }
                
            }
        }
        
        
    }
    
}
