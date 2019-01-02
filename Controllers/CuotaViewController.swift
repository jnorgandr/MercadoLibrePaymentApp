//
//  CuotaViewController.swift
//  PaymentApp
//
//  Created by minti on 12/31/18.
//  Copyright © 2018 studiominti. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

let apiInstallmentSource = "https://api.mercadopago.com/v1/payment_methods/installments?public_key=444a9ef5-8a6b-429f-abdf-587639155d88&amount=15&payment_method_id=visa&issuer.id=288"


class CuotaViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Considering previous choice
    var apiBanksURL = apiInstallmentSource + "&amount=\(CompraSingleton.shared.amount)&payment_method_id=\(CompraSingleton.shared.paymentId)&issuer.id=\(CompraSingleton.shared.issuerId)"

    @IBOutlet weak var installmentsPickerView: UIPickerView!
    
    var cantidadDeCuotas: [MedioCuota] = []
    
    override func viewDidLoad() {
        print("apiBanksURL:" + apiBanksURL )
        
        print("el banco seleccionado es:" + CompraSingleton.shared.bankName )
        super.viewDidLoad()
        getInstallmentsMethods()
        installmentsPickerView.delegate = self
        installmentsPickerView.dataSource = self

        // Do any additional setup after loading the view.
        
        //View BackGround Color
        view.setGradientBackground(colorOne: Colors.darkYellow, colorTwo: Colors.white)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cantidadDeCuotas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        CompraSingleton.shared.recommendedMessage = cantidadDeCuotas[row].recommendedMessage
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cantidadDeCuotas[row].recommendedMessage
    }
    
    // MARK: -  Update Medios de Pago
    
    func updateMediosDePago() {
        
        for cuota in cantidadDeCuotas {
           print("Mensaje:\(cuota.recommendedMessage)")
            
            self.installmentsPickerView.reloadAllComponents()
            CompraSingleton.shared.recommendedMessage = cantidadDeCuotas[0].recommendedMessage
            
        }
        
    }
    
    // MARK: -  Get Installments Methods
    
    func getInstallmentsMethods() {
        
        Alamofire.request(apiBanksURL).responseJSON { response in
            
            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                //print("Data: \(utf8Text)") // original server data as UTF8 string
                
                if let dataFromString = utf8Text.data(using: .utf8, allowLossyConversion: false) {
                    let json = try! JSON(data: dataFromString)
                    let mercadoLibreArray = json.array
                    // If json is .Dictionary
                    
                    let payerCostArray = mercadoLibreArray![0]["payer_costs"].array
                    
                    for payerValues in payerCostArray! {
                        
                        let cantidadCuotas :MedioCuota = MedioCuota()
                        
                        let payOption = payerValues["recommended_message"].string
                        cantidadCuotas.recommendedMessage = payOption!
                        
                        self.cantidadDeCuotas.append(cantidadCuotas)
                    }
                    
                    self.updateMediosDePago()
                }
                
            }
        }
        
        
    }
    
    @IBAction func finishSaleButton(_ sender: Any) {
        CompraSingleton.shared.buyFinished = true
    }
    
}

