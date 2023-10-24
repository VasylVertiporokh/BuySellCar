//
//  ImageAsset+Extension.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 05/10/2023.
//

import Foundation

// MARK: - ImageResources enum
enum ImageResources: Hashable {
    case fromData(Data?)
    case fromAssets(ImageAsset)
    case formRemote(String)
    
    var imageData: Data? {
        switch self {
        case .fromData(let data):               return data
        case .fromAssets(let imageAsset):       return imageAsset.image.pngData()
        case .formRemote:                       return nil
        }
    }
}

extension ImageAsset: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(image)
    }
    
    static func == (lhs: ImageAsset, rhs: ImageAsset) -> Bool {
        return lhs.image == rhs.image
    }
}
