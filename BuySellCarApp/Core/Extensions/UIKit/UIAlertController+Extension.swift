//
//  UIAlertController+Extension.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 22.05.2023.
//

import Foundation
import Combine
import UIKit

enum MediaSourceType {
    case camera
    case gallery
}

extension UIAlertController {
    class func displayAlert(parmAlert: UIAlertController) {
        guard let window = UIWindow.key else { return }
        window.rootViewController?.present(parmAlert, animated: true, completion: nil)
    }
    
    // MARK: - Media source type action sheet
    class func galleryOrCameraActionSheet() -> AnyPublisher<MediaSourceType, Never> {
        let selectionSubject = PassthroughSubject<MediaSourceType, Never>()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cameraAction = UIAlertAction(title: "Take picture", style: .default) { _ in
            selectionSubject.send(.camera)
        }
        cameraAction.setActionTitleColor(Colors.buttonDarkGray.color)
    
        let galleryAction = UIAlertAction(title: "Select from album", style: .default) { _ in
            selectionSubject.send(.gallery)
        }
        galleryAction.setActionTitleColor(Colors.buttonDarkGray.color)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { _ in }
        
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        displayAlert(parmAlert: alert)
        
        return selectionSubject.eraseToAnyPublisher()
    }
    
    class func deleteSelectedPhotoActionSheet() -> AnyPublisher<Void, Never> {
        let deleteSubject = PassthroughSubject<Void, Never>()
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete picture", style: .destructive) { _ in
            deleteSubject.send()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in }
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        displayAlert(parmAlert: alert)
        
        return deleteSubject.eraseToAnyPublisher()
    }
    
    class func showAlert(model: UIAlertControllerModel) {
        let alertController = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: model.preferredStyle
        )
        
        alertController.addAction(
            .init(
                title: model.confirmButtonTitle,
                style: model.confirmActionStyle,
                handler: { _ in
                    model.confirmAction?()
                }
            )
        )
        
        alertController.addAction(
            .init(
                title:  model.discardButtonTitle,
                style: model.discardActionStyle,
                handler: { _ in
                    model.discardAction?()
                }
            )
        )
        displayAlert(parmAlert: alertController)
    }
}
