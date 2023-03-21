//
//  EditUserProfileViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import UIKit

final class EditUserProfileViewController: BaseViewController<EditUserProfileViewModel> {
    // MARK: - Views
    private let contentView = EditUserProfileView()
    
    // MARK: - Actions
    private lazy var uploadAvatarAction: UIAction = {
        let action = UIAction(title: "Update photo", image: Assets.addAvatarIcon.image) { [weak self] _ in
            guard let self = self else { return }
            self.openImagePickerController()
        }
        action.setFont(FontFamily.Montserrat.medium.font(size: 16))
        return action
    }()
    
    private lazy var deleteAvatarAction: UIAction = {
        let action = UIAction(title: "Delete photo", image: Assets.deleteAvatarIcon.image) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.deleteAvatar()
        }
        action.setFont(FontFamily.Montserrat.medium.font(size: 16))
        return action
    }()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        configureNavigationBar()
    }
    
    private func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .logout:
                    viewModel.logout()
                }
            }
            .store(in: &cancellables)
        viewModel.eventsPublisher
            .sink { [unowned self] events in
                switch events {
                case .showUserInfo(let userModel):
                    contentView.setUserInfo(userModel)
                    configureNavigationBar(isAvatarAvailable: !userModel.userAvatar.isNilOrEmpty)
                }
            }
            .store(in: &cancellables)
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
    func configureNavigationBar(isAvatarAvailable: Bool = false) {
        title = Localization.editProfile.uppercased()
        deleteAvatarAction.attributes = isAvatarAvailable ? [] : .hidden
        let navItem = UIBarButtonItem(image: UIImage(systemName: "gear"), menu: createMenu())
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = navItem
    }
    
    func createMenu() -> UIMenu {
        let menu = UIMenu(children: [uploadAvatarAction, deleteAvatarAction])
        return menu
    }
    
    func openImagePickerController() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}
