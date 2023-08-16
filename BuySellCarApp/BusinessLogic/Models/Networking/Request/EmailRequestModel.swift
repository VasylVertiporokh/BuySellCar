//
//  EmailRequestModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 16/08/2023.
//

import Foundation

struct EmailRequestModel: Encodable {
    let adsName: String
    let emailBody: String?
    let senderName: String
    let senderPhoneNumber: String
    let senderEmail: String
    
    // MARK: - Init from domain model
    init(model: EmailDomainModel) {
        self.adsName = model.sendingInfo.adsName
        self.emailBody = model.emailBody
        self.senderName = model.senderName
        self.senderPhoneNumber = model.senderPhoneNumber
        self.senderEmail = model.senderEmail
    }
}
