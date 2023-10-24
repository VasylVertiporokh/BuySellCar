//
//  Optional+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 21.03.2023.
//

import Foundation
import Kingfisher

// MARK: - Optional String
extension Optional where Wrapped == String {
    var isNotEmpty: Bool {
        return !(self?.isEmpty ?? true)
    }
    
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
    
    func loadImageDataFromString(completion: @escaping (Data?) -> Void) {
        guard let url = self,
              let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: imageUrl) { result in
            switch result {
            case .success(let value):
                let imageData = value.image.pngData()
                completion(imageData)
            case .failure:
                completion(nil)
            }
        }
    }
}

extension Optional {
    var isNil: Bool {
        return self == nil
    }
}

extension Optional where Wrapped == Int {
    var isNilOrZero: Bool {
        return self == nil || self == 0
    }
}
