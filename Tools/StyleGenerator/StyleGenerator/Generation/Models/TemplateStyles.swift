/**
protocol ButtonStyle {
  static var Accessory: Style { get }
  static var Action: Style { get }
  static var Default: Style { get }
}

protocol LabelStyle {
  static var Title: Style { get }
}

protocol TextStyle {
  static var Default: Style { get }
  static var Title: Style { get }
}

enum Styles: Resetable {

  // MARK: - Button
  
  enum Button: ButtonStyle {}

  // MARK: - Label
  
  enum Label: LabelStyle {}

  // MARK: - Text
  
  enum Text: TextStyle {}
}

extension Styles {
  enum StyleAttributes: String {
    case borderColor
    case cornerRadius
    case fontName
    case fontSize
    case label
    case text
    case textColor
    case uppercased
  }
}

*/