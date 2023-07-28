//
//  AddAdvertisementImageViewController.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 23.05.2023.
//

import UIKit

final class AddAdvertisementImageViewController: BaseViewController<AddAdvertisementImageViewModel> {
    // MARK: - Views
    private let contentView = AddAdvertisementImageView()
    
    // MARK: - Lifecycle
    override func loadView() {
        view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        setupBindings()
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AddAdvertisementImageViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        viewModel.addPhoto(image.jpegData(compressionQuality: 0.5))
        dismiss(animated: true)
    }
}

// MARK: - Private extension
private extension AddAdvertisementImageViewController {
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .adOrDeleteItem(let row):
                    switch row {
                    case .carImageRow(let adsPhotoModel):
                        viewModel.setSelectedCollageID(adsPhotoModel.id)
                        adsPhotoModel.withSelectedImage ? showDeleteSelectedPhotoAlert() : showGalleryOrCameraAlert()
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionPublisher
            .sink { [unowned self] sections in
                contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
    
    func configureNavigationBar() {
        title = "Define photos"
    }
    
    func showGalleryOrCameraAlert() {
        UIAlertController.galleryOrCameraActionSheet()
            .sink { [unowned self] sourceType in
                switch sourceType {
                case .camera:
                    openCamera()
                case .gallery:
                    openGallery()
                }
            }
            .store(in: &cancellables)
    }
    
    func showDeleteSelectedPhotoAlert() {
            UIAlertController.deleteSelectedPhotoActionSheet()
                .sink { [unowned self] _ in
                    viewModel.deleteSelectedPhoto()
                }
                .store(in: &cancellables)
    }
    
    func openGallery() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func openCamera() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.showsCameraControls = true
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}
