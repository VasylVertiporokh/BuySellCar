// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
internal enum Localization {
  /// Ad successfully created! Now you can see your ad in the list Selling.
  internal static let adsCreatedSuccessfully = Localization.tr("Localizable", "ads-created-successfully", fallback: "Ad successfully created! Now you can see your ad in the list Selling.")
  /// Cancel
  internal static let cancel = Localization.tr("Localizable", "cancel", fallback: "Cancel")
  /// Choose option
  internal static let chooseOption = Localization.tr("Localizable", "choose-option", fallback: "Choose option")
  /// Confirm password
  internal static let confirmPassword = Localization.tr("Localizable", "confirm-password", fallback: "Confirm password")
  /// Continue
  internal static let `continue` = Localization.tr("Localizable", "continue", fallback: "Continue")
  /// Create account
  internal static let createAccountTitle = Localization.tr("Localizable", "create-account-title", fallback: "Create account")
  /// You can create new account
  internal static let createNewAccount = Localization.tr("Localizable", "create-new-account", fallback: "You can create new account")
  /// Create ad
  internal static let createAdButtonTitle = Localization.tr("Localizable", "createAdButtonTitle", fallback: "Create ad")
  /// Oops something went wrong
  internal static let defaultMessage = Localization.tr("Localizable", "defaultMessage", fallback: "Oops something went wrong")
  /// Are you sure you want to delete the ad?
  internal static let deleteAdsMessage = Localization.tr("Localizable", "delete-ads-message", fallback: "Are you sure you want to delete the ad?")
  /// The ad will be removed
  internal static let deleteAdsTitle = Localization.tr("Localizable", "delete-ads-title", fallback: "The ad will be removed")
  /// If you continue all data will be lost
  internal static let discardCreationMessage = Localization.tr("Localizable", "discard-creation-message", fallback: "If you continue all data will be lost")
  /// Do you want cancel creation
  internal static let discardCreationTitle = Localization.tr("Localizable", "discard-creation-title", fallback: "Do you want cancel creation")
  /// Done
  internal static let done = Localization.tr("Localizable", "done", fallback: "Done")
  /// Edit profile
  internal static let editProfile = Localization.tr("Localizable", "edit-profile", fallback: "Edit profile")
  /// User edited successfully
  internal static let editedSuccessfully = Localization.tr("Localizable", "edited-successfully", fallback: "User edited successfully")
  /// Email
  internal static let email = Localization.tr("Localizable", "email", fallback: "Email")
  /// You can send your feedback and recommendations, it is very important for us
  internal static let emailHeader = Localization.tr("Localizable", "emailHeader", fallback: "You can send your feedback and recommendations, it is very important for us")
  /// Localizable.strings
  ///   MVVMSkeleton
  internal static let error = Localization.tr("Localizable", "error", fallback: "Error")
  /// Forgot password?
  internal static let forgotPassword = Localization.tr("Localizable", "forgot-password", fallback: "Forgot password?")
  /// Logout
  internal static let logout = Localization.tr("Localizable", "logout", fallback: "Logout")
  /// Name
  internal static let name = Localization.tr("Localizable", "name", fallback: "Name")
  /// OK
  internal static let ok = Localization.tr("Localizable", "ok", fallback: "OK")
  /// OR
  internal static let or = Localization.tr("Localizable", "or", fallback: "OR")
  /// Password
  internal static let password = Localization.tr("Localizable", "password", fallback: "Password")
  /// Recommendation
  internal static let recommendation = Localization.tr("Localizable", "recommendation", fallback: "Recommendation")
  /// Restore
  internal static let restore = Localization.tr("Localizable", "restore", fallback: "Restore")
  /// Search
  internal static let search = Localization.tr("Localizable", "search", fallback: "Search")
  /// %@ results
  internal static func searchResultButton(_ p1: Any) -> String {
    return Localization.tr("Localizable", "search-Result-Button", String(describing: p1), fallback: "%@ results")
  }
  /// Selling
  internal static let selling = Localization.tr("Localizable", "selling", fallback: "Selling")
  /// Settings
  internal static let settings = Localization.tr("Localizable", "settings", fallback: "Settings")
  /// Sign In
  internal static let signIn = Localization.tr("Localizable", "sign-in", fallback: "Sign In")
  /// Sign Up
  internal static let signUp = Localization.tr("Localizable", "sign-up", fallback: "Sign Up")
  /// Skip
  internal static let skip = Localization.tr("Localizable", "skip", fallback: "Skip")
  /// Successfully
  internal static let successfullyAlertTitle = Localization.tr("Localizable", "successfully-alert-title", fallback: "Successfully")
  /// Your account has been created, you can now log in
  internal static let successfullyCreationMessage = Localization.tr("Localizable", "successfully-creation-message", fallback: "Your account has been created, you can now log in")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension Localization {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
    let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

// swiftlint:disable convenience_type
private final class BundleToken {
  static let bundle: Bundle = {
    #if SWIFT_PACKAGE
    return Bundle.module
    #else
    return Bundle(for: BundleToken.self)
    #endif
  }()
}
// swiftlint:enable convenience_type
