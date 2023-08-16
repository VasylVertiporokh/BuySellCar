//
//  TextEditor+Extension.swift
//  BuySellCarApp
//
//  Created by Vasia Vertiporoh on 14/08/2023.
//

import SwiftUI

extension TextEditor {
    @ViewBuilder func hideBackground() -> some View {
        if #available(iOS 16, *) {
            self.scrollContentBackground(.hidden)
        } else {
            self
        }
    }
}
