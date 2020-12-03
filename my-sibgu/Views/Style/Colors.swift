//
//  Colors.swift
//  my-sibgu
//
//  Created by art-off on 27.11.2020.
//

import UIKit


class Colors {
    
//    static var backgroungColor: UIColor {
//        if #available(iOS 13, *) {
//            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
//                if UITraitCollection.userInterfaceStyle == .dark {
//                    /// Return the color for Dark Mode
//                    // было 15
//                    //return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
//                    return UIColor.systemBackground
//                } else {
//                    /// Return the color for Light Mode
//                    // было 240
//                    return UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
//                    //return UIColor.systemGray6
//                }
//            }
//        } else {
//            /// Return a fallback color for iOS 12 and lower.
//            //return UIColor.systemGray6
//            return UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
//        }
//    }
//
//    static var contentColor: UIColor {
//        if #available(iOS 13, *) {
//            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
//                if UITraitCollection.userInterfaceStyle == .dark {
//                    /// Return the color for Dark Mode
//                    return UIColor(red: 25.0/255.0, green: 25.0/255.0, blue: 25.0/255.0, alpha: 1.0)
//                } else {
//                    /// Return the color for Light Mode
//                    return UIColor.systemBackground
//                }
//            }
//        } else {
//            /// Return a fallback color for iOS 12 and lower.
//            return UIColor.white
//        }
//    }
//
//    static var topBarColor: UIColor {
//        if #available(iOS 13, *){
//            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
//                if UITraitCollection.userInterfaceStyle == .dark {
//                    /// Return the color for Dark Mode
//                    return UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)
//                } else {
//                    /// Return the color for Light Mode
//                    return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 245.0/255.0)
//                }
//            }
//        } else {
//            return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 245.0/255.0)
//        }
//    }
//
//    static var label: UIColor {
//        if #available(iOS 13, *) {
//            return UIColor.label
//        } else {
//            /// Return a fallback color for iOS 12 and lower.
//            return UIColor.black
//        }
//    }
//    
    static var sibsuBlue: UIColor {
        return UIColor(red: 75.0/255.0, green: 123.0/255.0, blue: 184.0/255.0, alpha: 1.0)
    }
    
    static var sibsuGreen: UIColor {
        return UIColor(red: 138.0/255.0, green: 189.0/255.0, blue: 100.0/255.0, alpha: 1.0)
    }
    
    static var myBlue: UIColor {
        return UIColor(red: 22.0/255.0, green: 89.0/255.0, blue: 132.0/255.0, alpha: 1.0)
    }
    
    static var orange: UIColor {
        return UIColor(hexString: "#F48041")
    }
    
    static var green: UIColor {
        return UIColor(hexString: "#359f2f")
    }
    
    static var red: UIColor {
        return UIColor(red: 255.0/255.0, green: 117.0/255.0, blue: 118.0/255.0, alpha: 1)
    }
    
    static var purple: UIColor {
        return UIColor(hexString: "#c0a747")
    }
    
//    static var blue: UIColor {
//        return UIColor(hexString: "#097ABB")
//    }
//
//    static var black: UIColor {
//        if #available(iOS 13, *) {
//            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
//                if UITraitCollection.userInterfaceStyle == .dark {
//                    /// Return the color for Dark Mode
//                    return UIColor.white
//                } else {
//                    /// Return the color for Light Mode
//                    return UIColor.black
//                }
//            }
//        } else {
//            /// Return a fallback color for iOS 12 and lower.
//            return UIColor.black
//        }
//    }
    
}
