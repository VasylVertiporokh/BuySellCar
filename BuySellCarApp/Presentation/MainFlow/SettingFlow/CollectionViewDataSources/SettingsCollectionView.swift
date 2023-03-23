//
//  SettingsCollectionView.swift
//  BuySellCarApp
//
//  Created by Vasil Vertiporokh on 20.03.2023.
//

import Foundation
import UIKit

// MARK: - Sections
enum SettingsSection: Int, CaseIterable {
    case userProfile
    case user
    case feedback
    case other
}

// MARK: - Rows model
struct UserProfileCellModel: Hashable {
    let lastProfileUpdate: Int?
    let username: String
    let email: String
    let avatar: URL?
}

// MARK: - Settings rows
enum SettingsRow: Hashable {
    case userProfile(model: UserProfileCellModel)
    case profile
    case notification
    case feedback
    case recommend
    case outputData
    case conditionsAgreements
    case privacyPolicy
    case consentProcessing
    case privacyManager
    case usedLibraries
    
    var title: String? {
        switch self {
        case .userProfile:
            return "User Profile"
        case .profile:
            return "Profile"
        case .notification:
            return "Notifications"
        case .feedback:
            return "Feedback"
        case .recommend:
            return "Recommend"
        case .outputData:
            return "Output data"
        case .conditionsAgreements:
            return "Conditions for concluding agreements"
        case .privacyPolicy:
            return "Privacy policy"
        case .consentProcessing:
            return "Consent to data processing"
        case .privacyManager:
            return "Privacy Manager"
        case .usedLibraries:
            return "Used libraries"
        }
    }
    
    func cellFor(collectionView: UICollectionView, indexPath: IndexPath, identifier: String) -> UICollectionViewCell {
        switch self {
        case .userProfile(let model):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userProfileCell", for: indexPath) as! UserInfoListCell
            cell.cellItem = model
            return cell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "settingsCell", for: indexPath) as! SettingsListCell
            cell.title = title
            return cell
        }
    }
}
