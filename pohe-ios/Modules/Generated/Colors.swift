// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// swiftlint:disable operator_usage_whitespace
extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

// swiftlint:disable identifier_name line_length type_body_length
struct ColorName {
  let rgbaValue: UInt32
  var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#bfa825"></span>
  /// Alpha: 100% <br/> (0xbfa825ff)
  static let colorAccent = ColorName(rgbaValue: 0xbfa825ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e6edf4"></span>
  /// Alpha: 100% <br/> (0xe6edf4ff)
  static let colorDark = ColorName(rgbaValue: 0xe6edf4ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#f0f8ff"></span>
  /// Alpha: 100% <br/> (0xf0f8ffff)
  static let colorLight = ColorName(rgbaValue: 0xf0f8ffff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#94ccc3"></span>
  /// Alpha: 100% <br/> (0x94ccc3ff)
  static let colorPrimary = ColorName(rgbaValue: 0x94ccc3ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#85bbb2"></span>
  /// Alpha: 100% <br/> (0x85bbb2ff)
  static let colorPrimaryDark = ColorName(rgbaValue: 0x85bbb2ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#e3ebea"></span>
  /// Alpha: 100% <br/> (0xe3ebeaff)
  static let darkAccent = ColorName(rgbaValue: 0xe3ebeaff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
  static let white = ColorName(rgbaValue: 0xffffffff)
}
// swiftlint:enable identifier_name line_length type_body_length

extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
