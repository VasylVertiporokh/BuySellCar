//
//  String+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 31.05.2023.
//

import Foundation
import Kingfisher

extension String {
    func toSimpleNumberFormat() -> Self {
        let numberFormatter = NumberFormatter()
        var formattedString = ""
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = " "
        numberFormatter.groupingSize = 3
        
        if let number = numberFormatter.number(from: self.replacingOccurrences(of: " ", with: "")) {
            formattedString = numberFormatter.string(from: number) ?? ""
        }
        return formattedString
    }
    
    func loadImageDataFromString(completion: @escaping (Data?) -> Void) {
        guard let imageUrl = URL(string: self) else {
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
