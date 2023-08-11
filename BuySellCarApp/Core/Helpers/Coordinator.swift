//
//  Coordinator.swift
//  MVVMSkeleton
//
//

import UIKit
import Combine

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    var didFinishPublisher: AnyPublisher<Void, Never> { get }
    
    func start()
}

extension Coordinator {
    func addChild(coordinator: Coordinator) {
        self.childCoordinators.append(coordinator)
    }

    func removeChild(coordinator: Coordinator) {
        self.childCoordinators = childCoordinators.filter { $0 !== coordinator }
    }
    
    func setRoot(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController.setViewControllers([viewController], animated: animated)
    }
    
    func setRoot(_ viewControllers: [UIViewController], animated: Bool = true) {
        self.navigationController.setViewControllers(viewControllers, animated: animated)
    }
    
    func push(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController.pushViewController(viewController, animated: animated)
    }
    
    func pop(animated: Bool = true) {
        self.navigationController.popViewController(animated: animated)
    }
    
    func popToRoot(animated: Bool = true) {
        self.navigationController.popToRootViewController(animated: animated)
    }
    
    func present(_ viewController: UIViewController, animated: Bool = true) {
        self.navigationController.present(viewController, animated: animated)
    }
    
    func presentPresentationStyle(_ viewController: UIViewController, animated: Bool = false, style: UIModalPresentationStyle) {
        viewController.modalPresentationStyle = style
        self.navigationController.present(viewController, animated: animated)
    }
    
    func presentWithStyle(_ viewController: UIViewController, animated: Bool = true, style: UIModalPresentationStyle) {
        viewController.modalPresentationStyle = style
        self.navigationController.present(viewController, animated: animated)
    }
    
    func dismiss(animated: Bool = true) {
        self.navigationController.dismiss(animated: true)
    }
}
