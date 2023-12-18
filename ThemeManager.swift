//
//  ThemeManager.swift
//  Navigation

import Foundation
import UIKit

struct Theme {
    enum ThemeType {
        case light
        case dark
    }
    
    var type: ThemeType
    var palette: ColorPalette
    
    static var current: Theme = Theme.dark {
        didSet {
            func changeTheme(for view: UIView) {
                view.applyTheme(current)
                view.subviews.forEach { view in
                    changeTheme(for: view)
                }
            }
            
            let scene = UIApplication.shared.connectedScenes.first
            let mainWindow = (scene as? UIWindowScene)?.keyWindow
            mainWindow?.subviews.forEach({ view in
                changeTheme(for: view)
            })
             
        }
    }
    static var light = Theme(type: ThemeType.light, palette: ColorPalette.colorLight)
    static var dark = Theme(type: ThemeType.dark, palette: ColorPalette.colorDark)
}

struct ColorPalette {
    let labelColor: UIColor
    let viewColor: UIColor
    let backgroundColor: UIColor
    let textFieldColor: UIColor
    let barTintColor: UIColor
    
    static let colorLight = ColorPalette(labelColor: .black, viewColor: .white, backgroundColor: .white, textFieldColor: .black, barTintColor: .white)
    static let colorDark = ColorPalette(labelColor: .white, viewColor: .darkGray, backgroundColor: .black, textFieldColor: .white, barTintColor: .white)
}

protocol Themable {
    func applyTheme(_ theme: Theme)
}

extension UIView: Themable {
    func applyTheme(_ theme: Theme) {
        if (self is UILabel) {
            (self as! UILabel).textColor = theme.palette.labelColor
            (self as! UILabel).backgroundColor = .clear
            return
        }
        
        if (self is UIStackView) {
            (self as! UIStackView).backgroundColor = theme.palette.backgroundColor
            return
        }
        
        
        if (self is UIImageView) {
            (self as! UIImageView).backgroundColor = theme.palette.viewColor
            
            return
        }
         
        
        if (self is UIButton) {
            (self as! UIButton).tintColor = theme.palette.labelColor
            return
        }
        
        if (self is UITextField) {
            (self as! UITextField).textColor = theme.palette.textFieldColor
            
            return
        }
        
        if (self is UIStackView) {
            (self as! UIStackView).backgroundColor = theme.palette.viewColor
            return
        }
        
        if (self is UINavigationBar) {
            (self as! UINavigationBar).barTintColor = theme.palette.barTintColor
            return
        }
        
        if (self is UITabBar) {
            (self as! UITabBar).barTintColor = theme.palette.barTintColor
            return
        }
        
        if (self is UITableView) {
            (self as! UITableView).backgroundColor = theme.palette.viewColor
            return
        }
        
        if (self is UITableViewCell) {
            (self as! UITableViewCell).backgroundColor = theme.palette.viewColor
            return
        }
        
        if (self is UICollectionView) {
            (self as! UICollectionView).backgroundColor = theme.palette.viewColor
            return
        }
        
        if (self is UICollectionViewCell) {
            (self as! UICollectionViewCell).backgroundColor = theme.palette.viewColor
            return
        }
        
        if (self is UITableViewHeaderFooterView) {
            (self as! UITableViewHeaderFooterView).backgroundColor = theme.palette.viewColor
            return
        }
        
        if (self is UIScrollView) {
            (self as! UIScrollView).backgroundColor = theme.palette.viewColor
            return
        }
        
     
        backgroundColor = theme.palette.viewColor
    }
}

extension UIColor {
    static func createColor(lightMode: UIColor, darkMode: UIColor) -> UIColor {
        guard #available(iOS 13.0, *) else { return lightMode }
        return UIColor { (traitCollection) -> UIColor in
            return traitCollection.userInterfaceStyle == .light ? lightMode: darkMode
        }
    }
}
