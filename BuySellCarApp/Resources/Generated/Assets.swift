// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(macOS)
  import AppKit
#elseif os(iOS)
  import UIKit
#elseif os(tvOS) || os(watchOS)
  import UIKit
#endif
#if canImport(SwiftUI)
  import SwiftUI
#endif

// Deprecated typealiases
@available(*, deprecated, renamed: "ImageAsset.Image", message: "This typealias will be removed in SwiftGen 7.0")
internal typealias AssetImageTypeAlias = ImageAsset.Image

// swiftlint:disable superfluous_disable_command file_length implicit_return

// MARK: - Asset Catalogs

// swiftlint:disable identifier_name line_length nesting type_body_length type_name
internal enum Assets {
  internal static let addMoreIcon = ImageAsset(name: "addMoreIcon")
  internal static let backRightSideIcon = ImageAsset(name: "backRightSideIcon")
  internal static let backSideIcon = ImageAsset(name: "backSideIcon")
  internal static let bodySideIcon = ImageAsset(name: "bodySideIcon")
  internal static let checkMark = ImageAsset(name: "checkMark")
  internal static let dashboardIcon = ImageAsset(name: "dashboardIcon")
  internal static let frontLeftSizeIcon = ImageAsset(name: "frontLeftSizeIcon")
  internal static let frontSideIcon = ImageAsset(name: "frontSideIcon")
  internal static let interiorIcon = ImageAsset(name: "interiorIcon")
  internal static let cabrioBody = ImageAsset(name: "cabrioBody")
  internal static let compactBody = ImageAsset(name: "compactBody")
  internal static let hatchbackBody = ImageAsset(name: "hatchbackBody")
  internal static let sedanBody = ImageAsset(name: "sedanBody")
  internal static let stationWagonBody = ImageAsset(name: "stationWagonBody")
  internal static let suvBody = ImageAsset(name: "suvBody")
  internal static let transporterBody = ImageAsset(name: "transporterBody")
  internal static let vanBody = ImageAsset(name: "vanBody")
  internal static let audiLogo = ImageAsset(name: "audiLogo")
  internal static let bmwLogo = ImageAsset(name: "bmwLogo")
  internal static let fiatLogo = ImageAsset(name: "fiatLogo")
  internal static let fordLogo = ImageAsset(name: "fordLogo")
  internal static let icons8Tesla = ImageAsset(name: "icons8-tesla")
  internal static let mercedesLogo = ImageAsset(name: "mercedesLogo")
  internal static let nissanLogo = ImageAsset(name: "nissanLogo")
  internal static let renaultLogo = ImageAsset(name: "renaultLogo")
  internal static let volkswagenLogo = ImageAsset(name: "volkswagenLogo")
  internal static let compact = ImageAsset(name: "compact")
  internal static let electric = ImageAsset(name: "electric")
  internal static let family = ImageAsset(name: "family")
  internal static let hybrid = ImageAsset(name: "hybrid")
  internal static let premium = ImageAsset(name: "premium")
  internal static let roadTrip = ImageAsset(name: "roadTrip")
  internal static let suv = ImageAsset(name: "suv")
  internal static let vintage = ImageAsset(name: "vintage")
  internal static let addAdv = ImageAsset(name: "addAdv")
  internal static let addAvatarIcon = ImageAsset(name: "addAvatarIcon")
  internal static let addIcon = ImageAsset(name: "addIcon")
  internal static let addUserIcon = ImageAsset(name: "addUserIcon")
  internal static let arrow = ImageAsset(name: "arrow")
  internal static let camera = ImageAsset(name: "camera")
  internal static let carImage = ImageAsset(name: "carImage")
  internal static let carPlaceholder = ImageAsset(name: "carPlaceholder")
  internal static let carSellIcon = ImageAsset(name: "carSellIcon")
  internal static let closeCircleIcon = ImageAsset(name: "closeCircleIcon")
  internal static let closeIcon = ImageAsset(name: "closeIcon")
  internal static let deleteAvatarIcon = ImageAsset(name: "deleteAvatarIcon")
  internal static let editIcon = ImageAsset(name: "editIcon")
  internal static let emailIcon = ImageAsset(name: "emailIcon")
  internal static let filterIcon = ImageAsset(name: "filterIcon")
  internal static let gtr = ImageAsset(name: "gtr")
  internal static let heart = ImageAsset(name: "heart")
  internal static let keyIcon = ImageAsset(name: "keyIcon")
  internal static let logoutIcon = ImageAsset(name: "logoutIcon")
  internal static let map = ImageAsset(name: "map")
  internal static let passwordIcon = ImageAsset(name: "passwordIcon")
  internal static let searchIcon = ImageAsset(name: "searchIcon")
  internal static let settingsIcon = ImageAsset(name: "settingsIcon")
  internal static let trashIcon = ImageAsset(name: "trashIcon")
  internal static let user1 = ImageAsset(name: "user1")
  internal static let userIcon = ImageAsset(name: "userIcon")
  internal static let userPlaceholder = ImageAsset(name: "userPlaceholder")
  internal static let vehicleDataIcon = ImageAsset(name: "vehicleDataIcon")
}
// swiftlint:enable identifier_name line_length nesting type_body_length type_name

// MARK: - Implementation Details

internal struct ImageAsset {
  internal fileprivate(set) var name: String

  #if os(macOS)
  internal typealias Image = NSImage
  #elseif os(iOS) || os(tvOS) || os(watchOS)
  internal typealias Image = UIImage
  #endif

  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, macOS 10.7, *)
  internal var image: Image {
    let bundle = BundleToken.bundle
    #if os(iOS) || os(tvOS)
    let image = Image(named: name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    let name = NSImage.Name(self.name)
    let image = (bundle == .main) ? NSImage(named: name) : bundle.image(forResource: name)
    #elseif os(watchOS)
    let image = Image(named: name)
    #endif
    guard let result = image else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }

  #if os(iOS) || os(tvOS)
  @available(iOS 8.0, tvOS 9.0, *)
  internal func image(compatibleWith traitCollection: UITraitCollection) -> Image {
    let bundle = BundleToken.bundle
    guard let result = Image(named: name, in: bundle, compatibleWith: traitCollection) else {
      fatalError("Unable to load image asset named \(name).")
    }
    return result
  }
  #endif

  #if canImport(SwiftUI)
  @available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
  internal var swiftUIImage: SwiftUI.Image {
    SwiftUI.Image(asset: self)
  }
  #endif
}

internal extension ImageAsset.Image {
  @available(iOS 8.0, tvOS 9.0, watchOS 2.0, *)
  @available(macOS, deprecated,
    message: "This initializer is unsafe on macOS, please use the ImageAsset.image property")
  convenience init?(asset: ImageAsset) {
    #if os(iOS) || os(tvOS)
    let bundle = BundleToken.bundle
    self.init(named: asset.name, in: bundle, compatibleWith: nil)
    #elseif os(macOS)
    self.init(named: NSImage.Name(asset.name))
    #elseif os(watchOS)
    self.init(named: asset.name)
    #endif
  }
}

#if canImport(SwiftUI)
@available(iOS 13.0, tvOS 13.0, watchOS 6.0, macOS 10.15, *)
internal extension SwiftUI.Image {
  init(asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle)
  }

  init(asset: ImageAsset, label: Text) {
    let bundle = BundleToken.bundle
    self.init(asset.name, bundle: bundle, label: label)
  }

  init(decorative asset: ImageAsset) {
    let bundle = BundleToken.bundle
    self.init(decorative: asset.name, bundle: bundle)
  }
}
#endif

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
