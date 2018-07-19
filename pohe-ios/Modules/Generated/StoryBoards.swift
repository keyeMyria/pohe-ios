// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

// swiftlint:disable sorted_imports
import Foundation
import UIKit
import pohe_ios

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

protocol StoryboardType {
  static var storyboardName: String { get }
}

extension StoryboardType {
  static var storyboard: UIStoryboard {
    let name = self.storyboardName
    return UIStoryboard(name: name, bundle: Bundle(for: BundleToken.self))
  }
}

struct SceneType<T: Any> {
  let storyboard: StoryboardType.Type
  let identifier: String

  func instantiate() -> T {
    let identifier = self.identifier
    guard let controller = storyboard.storyboard.instantiateViewController(withIdentifier: identifier) as? T else {
      fatalError("ViewController '\(identifier)' is not of the expected class \(T.self).")
    }
    return controller
  }
}

struct InitialSceneType<T: Any> {
  let storyboard: StoryboardType.Type

  func instantiate() -> T {
    guard let controller = storyboard.storyboard.instantiateInitialViewController() as? T else {
      fatalError("ViewController is not of the expected class \(T.self).")
    }
    return controller
  }
}

protocol SegueType: RawRepresentable { }

extension UIViewController {
  func perform<S: SegueType>(segue: S, sender: Any? = nil) where S.RawValue == String {
    let identifier = segue.rawValue
    performSegue(withIdentifier: identifier, sender: sender)
  }
}

// swiftlint:disable explicit_type_interface identifier_name line_length type_body_length type_name
enum StoryboardScene {
  enum ArticleViewController: StoryboardType {
    static let storyboardName = "ArticleViewController"

    static let initialScene = InitialSceneType<pohe_ios.ArticleViewController>(storyboard: ArticleViewController.self)
  }
  enum History: StoryboardType {
    static let storyboardName = "History"

    static let initialScene = InitialSceneType<UINavigationController>(storyboard: History.self)

    static let historyViewController = SceneType<pohe_ios.HistoryViewController>(storyboard: History.self, identifier: "HistoryViewController")
  }
  enum LaunchScreen: StoryboardType {
    static let storyboardName = "LaunchScreen"

    static let initialScene = InitialSceneType<UIViewController>(storyboard: LaunchScreen.self)
  }
  enum LocalWeb: StoryboardType {
    static let storyboardName = "LocalWeb"

    static let initialScene = InitialSceneType<UINavigationController>(storyboard: LocalWeb.self)

    static let localWebViewController = SceneType<pohe_ios.LocalWebViewController>(storyboard: LocalWeb.self, identifier: "LocalWebViewController")
  }
  enum Main: StoryboardType {
    static let storyboardName = "Main"

    static let initialScene = InitialSceneType<ViewController>(storyboard: Main.self)
  }
  enum MainViewController: StoryboardType {
    static let storyboardName = "MainViewController"

    static let initialScene = InitialSceneType<pohe_ios.MainViewController>(storyboard: MainViewController.self)
  }
  enum Menu: StoryboardType {
    static let storyboardName = "Menu"

    static let initialScene = InitialSceneType<UINavigationController>(storyboard: Menu.self)

    static let menuViewController = SceneType<pohe_ios.MenuViewController>(storyboard: Menu.self, identifier: "MenuViewController")
  }
  enum OpenSource: StoryboardType {
    static let storyboardName = "OpenSource"

    static let initialScene = InitialSceneType<UINavigationController>(storyboard: OpenSource.self)
  }
  enum PageViewController: StoryboardType {
    static let storyboardName = "PageViewController"

    static let initialScene = InitialSceneType<UINavigationController>(storyboard: PageViewController.self)

    static let pageViewController = SceneType<pohe_ios.PageViewController>(storyboard: PageViewController.self, identifier: "PageViewController")
  }
  enum Web: StoryboardType {
    static let storyboardName = "Web"

    static let initialScene = InitialSceneType<UINavigationController>(storyboard: Web.self)

    static let webViewController = SceneType<pohe_ios.WebViewController>(storyboard: Web.self, identifier: "WebViewController")
  }
}

enum StoryboardSegue {
  enum Menu: String, SegueType {
    case showBookmark
    case showHistory
    case showOpenSource
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length type_body_length type_name

private final class BundleToken {}
