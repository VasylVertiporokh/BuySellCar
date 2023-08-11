//
//  UserInfoUpdateRequestModel.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 16.03.2023.
//

import Foundation

struct UserInfoUpdateRequestModel: Encodable {
    var phoneNumber: String?
    var name: String?
    var userAvatar: String?
    var withWhatsAppAccount: Bool = false
    var isCommercialSales: Bool = false
}
