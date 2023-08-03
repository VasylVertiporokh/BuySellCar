//
//  BaseView.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine
import CombineCocoa

class BaseView: UIView {
    var cancellables = Set<AnyCancellable>()
}
