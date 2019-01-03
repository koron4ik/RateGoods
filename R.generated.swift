//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.color` struct is generated, and contains static references to 0 colors.
  struct color {
    fileprivate init() {}
  }
  
  /// This `R.file` struct is generated, and contains static references to 3 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")
    /// Resource file `Podfile`.
    static let podfile = Rswift.FileResource(bundle: R.hostingBundle, name: "Podfile", pathExtension: "")
    /// Resource file `mapstyle.json`.
    static let mapstyleJson = Rswift.FileResource(bundle: R.hostingBundle, name: "mapstyle", pathExtension: "json")
    
    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "Podfile", withExtension: "")`
    static func podfile(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.podfile
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    /// `bundle.url(forResource: "mapstyle", withExtension: "json")`
    static func mapstyleJson(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.mapstyleJson
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.font` struct is generated, and contains static references to 0 fonts.
  struct font {
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 1 images.
  struct image {
    /// Image `placeholder_image`.
    static let placeholder_image = Rswift.ImageResource(bundle: R.hostingBundle, name: "placeholder_image")
    
    /// `UIImage(named: "placeholder_image", bundle: ..., traitCollection: ...)`
    static func placeholder_image(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.placeholder_image, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.nib` struct is generated, and contains static references to 2 nibs.
  struct nib {
    /// Nib `StoreAddingPanel`.
    static let storeAddingPanel = _R.nib._StoreAddingPanel()
    /// Nib `StoreInfoPanel`.
    static let storeInfoPanel = _R.nib._StoreInfoPanel()
    
    /// `UINib(name: "StoreAddingPanel", in: bundle)`
    static func storeAddingPanel(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.storeAddingPanel)
    }
    
    /// `UINib(name: "StoreInfoPanel", in: bundle)`
    static func storeInfoPanel(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.storeInfoPanel)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 0 reuse identifiers.
  struct reuseIdentifier {
    fileprivate init() {}
  }
  
  /// This `R.segue` struct is generated, and contains static references to 0 view controllers.
  struct segue {
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 7 storyboards.
  struct storyboard {
    /// Storyboard `Favourites`.
    static let favourites = _R.storyboard.favourites()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Map`.
    static let map = _R.storyboard.map()
    /// Storyboard `Popular`.
    static let popular = _R.storyboard.popular()
    /// Storyboard `Search`.
    static let search = _R.storyboard.search()
    /// Storyboard `Settings`.
    static let settings = _R.storyboard.settings()
    
    /// `UIStoryboard(name: "Favourites", bundle: ...)`
    static func favourites(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.favourites)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    /// `UIStoryboard(name: "Map", bundle: ...)`
    static func map(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.map)
    }
    
    /// `UIStoryboard(name: "Popular", bundle: ...)`
    static func popular(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.popular)
    }
    
    /// `UIStoryboard(name: "Search", bundle: ...)`
    static func search(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.search)
    }
    
    /// `UIStoryboard(name: "Settings", bundle: ...)`
    static func settings(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.settings)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.string` struct is generated, and contains static references to 0 localization tables.
  struct string {
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
    try nib.validate()
  }
  
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _StoreAddingPanel.validate()
      try _StoreInfoPanel.validate()
    }
    
    struct _StoreAddingPanel: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "StoreAddingPanel"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> StoreAddingPanel? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? StoreAddingPanel
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "placeholder_image", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'placeholder_image' is used in nib 'StoreAddingPanel', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    struct _StoreInfoPanel: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "StoreInfoPanel"
      
      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [NSObject : AnyObject]? = nil) -> StoreInfoPanel? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? StoreInfoPanel
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "placeholder_image", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'placeholder_image' is used in nib 'StoreInfoPanel', but couldn't be loaded.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try main.validate()
      try popular.validate()
      try search.validate()
      try favourites.validate()
      try map.validate()
    }
    
    struct favourites: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let favouritesNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "FavouritesNavigationController")
      let name = "Favourites"
      
      func favouritesNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: favouritesNavigationController)
      }
      
      static func validate() throws {
        if _R.storyboard.favourites().favouritesNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'favouritesNavigationController' could not be loaded from storyboard 'Favourites' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let name = "Main"
      let tabsViewController = StoryboardViewControllerResource<UIKit.UITabBarController>(identifier: "TabsViewController")
      
      func tabsViewController(_: Void = ()) -> UIKit.UITabBarController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: tabsViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.main().tabsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'tabsViewController' could not be loaded from storyboard 'Main' as 'UIKit.UITabBarController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct map: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let mapNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "MapNavigationController")
      let name = "Map"
      let pulleyViewController = StoryboardViewControllerResource<MapViewController>(identifier: "PulleyViewController")
      
      func mapNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: mapNavigationController)
      }
      
      func pulleyViewController(_: Void = ()) -> MapViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: pulleyViewController)
      }
      
      static func validate() throws {
        if _R.storyboard.map().pulleyViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'pulleyViewController' could not be loaded from storyboard 'Map' as 'MapViewController'.") }
        if _R.storyboard.map().mapNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'mapNavigationController' could not be loaded from storyboard 'Map' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct popular: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let name = "Popular"
      let popularNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "PopularNavigationController")
      
      func popularNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: popularNavigationController)
      }
      
      static func validate() throws {
        if _R.storyboard.popular().popularNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'popularNavigationController' could not be loaded from storyboard 'Popular' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct search: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController
      
      let bundle = R.hostingBundle
      let name = "Search"
      let searchNavigationController = StoryboardViewControllerResource<UIKit.UINavigationController>(identifier: "SearchNavigationController")
      
      func searchNavigationController(_: Void = ()) -> UIKit.UINavigationController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: searchNavigationController)
      }
      
      static func validate() throws {
        if _R.storyboard.search().searchNavigationController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'searchNavigationController' could not be loaded from storyboard 'Search' as 'UIKit.UINavigationController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct settings: Rswift.StoryboardResourceType {
      let bundle = R.hostingBundle
      let name = "Settings"
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
