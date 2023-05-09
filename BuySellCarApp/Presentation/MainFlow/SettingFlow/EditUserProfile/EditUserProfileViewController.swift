//
//  EditUserProfileViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import UIKit
import Kingfisher

final class EditUserProfileViewController: BaseViewController<EditUserProfileViewModel> {
    // MARK: - Views
    private let contentView = EditUserProfileView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configureNavigationBar()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension EditUserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        
        viewModel.updateUserAvatar(image.jpegData(compressionQuality: 0.5) ?? Data())
        dismiss(animated: true)
    }
}

// MARK: - Private extension
private extension EditUserProfileViewController {
    func configureNavigationBar() {
        title = Localization.editProfile
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .logout:
                    viewModel.logout()
                case .updateUserAvatar:
                    openImagePickerController()
                case .deleteUserAvatar:
                    viewModel.deleteAvatar()
                case .saveChanges:
                    viewModel.updateUserInfo()
                case .nameChanged(let userName):
                    viewModel.setName(userName)
                case .phoneChanged(phoneNumber: let phoneNumber, isValid: let isValid):
                    viewModel.setPhone(phoneNumber, isValid: isValid)
                }
            }
            .store(in: &cancellables)
        
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .showUserInfo(let userModel):
                    contentView.configureView(userModel)
                case .successfulEditing:
                    successfulEditingAlert()
                }
            }
            .store(in: &cancellables)
        
        viewModel.validationPublisher
            .sink { [unowned self] in contentView.applyValidation(form: $0) }
            .store(in: &cancellables)
        
        keyboardHeightPublisher
            .sink { [unowned self] in contentView.setScrollViewOffSet(offSet: $0) }
            .store(in: &cancellables)
    }
    
    func openImagePickerController() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func successfulEditingAlert() {
        let alertController = UIAlertController(
            title: Localization.successfullyAlertTitle,
            message: Localization.editedSuccessfully,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: Localization.ok, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
