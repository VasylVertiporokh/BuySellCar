//
//  SettingsViewController.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    // MARK: - Views
    private let contentView = SettingsView()
    
    // MARK: - Navigation bar menu actions
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
    
    private lazy var logoutAction: UIAction = {
        let action = UIAction(title: "Logout", image: Assets.logoutIcon.image.withTintColor(.red)) { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.logout()
        }
        action.attributes = .destructive
        action.setFont(FontFamily.Montserrat.bold.font(size: 16))
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
}

// MARK: - Internal extension
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
private extension SettingsViewController {
    func configureNavigationBar() {
        title = Localization.settings.uppercased()
        let navItem = UIBarButtonItem(image: UIImage(systemName: "gear"), menu: createMenu())
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = navItem
    }
    
    func createMenu() -> UIMenu {
        let menu = UIMenu(children: [uploadAvatarAction, deleteAvatarAction, logoutAction])
        return menu
    }
    
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .logoutTapped:
                    viewModel.logout()
                case .rowSelected(let row):
                    print(row)
                }
            }
            .store(in: &cancellables)
        
        viewModel.$sections
            .sink { [unowned self] sections in
            contentView.setupSnapshot(sections: sections)
        }
        .store(in: &cancellables)
    }
    
    func openImagePickerController() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

