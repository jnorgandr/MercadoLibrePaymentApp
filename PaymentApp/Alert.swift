//
//  Alert.swift
//  PaymentApp
//
//  Created by minti on 1/1/19.
//  Copyright © 2019 studiominti. All rights reserved.
//

import Foundation
import UIKit



struct Alert {
    
    private static func showBasicAlert(on vc: UIViewController, with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true)
        
    }
    
    
   static func buyFinishedAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Compra Exitosa", message: "Pago de $\(CompraSingleton.shared.amount), Medio:\(CompraSingleton.shared.cardName), Banco:\(CompraSingleton.shared.bankName), Cuotas:\(CompraSingleton.shared.recommendedMessage)")
        
    }
}
