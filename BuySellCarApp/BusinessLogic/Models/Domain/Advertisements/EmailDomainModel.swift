//
//  EmailDomainModel.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 16/08/2023.
//

import Foundation

struct EmailDomainModel {
    var emailBody: String?
    let senderName: String
    let senderPhoneNumber: String
    let senderEmail: String
    let sendingInfo: SendindInfo

    struct SendindInfo {
        let adsId: String
        let adsName: String
    }
}
