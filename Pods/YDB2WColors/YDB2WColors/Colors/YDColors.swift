//
//  YDColors.swift
//  YDB2WColors
//
//  Created by Douglas Hennrich on 31/10/21.
//

import UIKit

public enum YDColors {
  public static var branding: UIColor { UIColor(r: 248, g: 0.0, b: 50.0) }
  public static var brandingHighlighted: UIColor { YDColors.branding.withAlphaComponent(0.5) }
  
  public static var black: UIColor { UIColor(r: 51, g: 51, b: 51) }
  public static var blackHighlighted: UIColor { YDColors.black.withAlphaComponent(0.5) }
  
  public static var white: UIColor { UIColor(white: 1.0, alpha: 1.0) }
  
  public static var separator: UIColor { UIColor(white: 232.0 / 255.0, alpha: 1.0) }
  
  // MARK: Red
  public struct Red {
    public static var primary: UIColor { UIColor(r: 248, g: 0, b: 50) }
    public static var primaryHighlighted: UIColor { YDColors.Red.primary.withAlphaComponent(0.5) }
    public static var primaryDisabled: UIColor { UIColor(r: 243.0, g: 128.0, b: 138.0) }
    
    public static var dark: UIColor { UIColor(r: 171.0, g: 0, b: 0) }
    
    public static var opaque: UIColor { UIColor(r: 255, g: 235, b: 238) }
    
    public static var night: UIColor { UIColor(r: 255, g: 69, b: 58) }
    
    public static var pale: UIColor { UIColor(r: 255, g: 243, b: 245) }
  }
  
  // MARK: Green
  public struct Green {
    public static var dark: UIColor { UIColor(r: 0, g: 177, b: 1) }
    
    public static var done: UIColor { UIColor(r: 7, g: 170, b: 7) }
    
    public static var opaque: UIColor { UIColor(r: 220, g: 237, b: 201) }
    
    public static var primary: UIColor { UIColor(r: 151, g: 202, b: 88.0) }
    
    public static var light: UIColor { UIColor(r: 153, g: 224, b: 2) }
    
    public static var night: UIColor { UIColor(r: 50, g: 215, b: 75) }
  }
  
  // MARK: Yellow
  public struct Yellow {
    public static var branding: UIColor { UIColor(r: 250, g: 215, b: 10) }
    
    public static var dark: UIColor { UIColor(r: 229, g: 157, b: 14) }
    
    public static var light: UIColor { UIColor(r: 255, g: 240, b: 2) }

    public static var night: UIColor { UIColor(r: 255, g: 214, b: 10) }

    public static var opaque: UIColor { UIColor(r: 255, g: 244, b: 180) }
  }
  
  // MARK: Blue
  public struct Blue {
    public static var dark: UIColor { UIColor(r: 25, g: 160, b: 230) }
    
    public static var light: UIColor { UIColor(r: 36, g: 203, b: 255) }

    public static var night: UIColor { UIColor(r: 100, g: 210, b: 255) }

    public static var opaque: UIColor { UIColor(r: 225, g: 245, b: 254) }
  }
  
  // MARK: Gray
  public struct Gray {
    public static var disabled: UIColor { UIColor(white: 232.0 / 255.0, alpha: 1.0) }

    public static var light: UIColor { UIColor(white: 136.0 / 255.0, alpha: 1.0) }
    public static var lightHighlighted: UIColor { YDColors.Gray.light.withAlphaComponent(0.5) }
    
    public static var medium: UIColor { UIColor(r: 102, g: 102, b: 102) }

    public static var night: UIColor { UIColor(white: 204.0 / 255.0, alpha: 1.0) }

    public static var opaque: UIColor { UIColor(white: 241.0 / 255.0, alpha: 1.0) }

    public static var surface: UIColor { UIColor(white: 248.0 / 255.0, alpha: 1.0) }
  }
}

// MARK: Color Extension
fileprivate extension UIColor {
  convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
    self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: 1.0)
  }

  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    self.init(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
  }
}
