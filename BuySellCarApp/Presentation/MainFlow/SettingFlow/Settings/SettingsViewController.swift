//
//  SettingsViewController.swift
//  MVVMSkeleton
//
//  Created by Roman Savchenko on 28.11.2021.
//

import UIKit
import MessageUI

final class SettingsViewController: BaseViewController<SettingsViewModel> {
    // MARK: - Views
    private let contentView = SettingsView()
    
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

// MARK: - MFMailComposeViewControllerDelegate
extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}

// MARK: - Private extension
private extension SettingsViewController {
    func configureNavigationBar() {
        title = Localization.profile.uppercased()
    }
    
    func setupBindings() {
        contentView.actionPublisher
            .sink { [unowned self] action in
                switch action {
                case .rowSelected(let row):
                    switch row {
                    case .userProfile, .profile:
                        viewModel.showEditProfile()
                    case .recommend, .feedback:
                        sendFeedbackOrRecommendation()
                    case .notification, .outputData, .conditionsAgreements, .privacyPolicy,
                            .consentProcessing, .privacyManager, .usedLibraries:
                        break
                    }
                }
            }
            .store(in: &cancellables)
        
        viewModel.sectionsAction
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] sections in
                contentView.setupSnapshot(sections: sections)
            }
            .store(in: &cancellables)
    }
    
    func sendFeedbackOrRecommendation() {
        guard MFMailComposeViewController.canSendMail() else {
            infoAlert()
            return
        }
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = self
        mail.setSubject(Localization.recommendation)
        mail.setToRecipients([Constants.devEmail])
        mail.setMessageBody("<p>\(Localization.emailHeader))</p>", isHTML: true)
        present(mail, animated: true)
    }
    
    func infoAlert() {
        let alertController = UIAlertController(
            title: Localization.error,
            message: Localization.defaultMessage,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: Localization.ok, style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Constants
private enum Constants {
    static let devEmail: String = "vasiavertiporoh17@gmail.com"
}
