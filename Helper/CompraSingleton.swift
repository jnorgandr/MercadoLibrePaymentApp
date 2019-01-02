//
//  CompraSingleton.swift
//  PaymentApp
//
//  Created by minti on 12/29/18.
//  Copyright © 2018 studiominti. All rights reserved.
//

class CompraSingleton {
    
    static let shared = CompraSingleton()
    
    var buyFinished: Bool?
    var amount = 0
    var cardName = ""
    var bankName = ""
    var paymentId = ""
    var issuerId = ""
    var recommendedMessage = ""
 
    //Initializer access level change now
    private init(){}
    
}
