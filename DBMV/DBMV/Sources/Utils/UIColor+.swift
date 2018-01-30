//
//  UIColor+.swift
//  DBMV
//
//  Created by tanyadong on 2018/1/29.
//  Copyright © 2018年 tanyadong. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
        guard red >= 0 && red <= 255 else { return nil }
        guard green >= 0 && green <= 255 else { return nil }
        guard blue >= 0 && blue <= 255 else { return nil }
        
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
    }
    
    
    convenience init?(hex: Int, transparency: CGFloat = 1) {
        var trans = transparency
        if trans < 0 { trans = 0 }
        if trans > 1 { trans = 1 }
        
        let red = (hex >> 16) & 0xff
        let green = (hex >> 8) & 0xff
        let blue = hex & 0xff
        self.init(red: red, green: green, blue: blue, transparency: trans)
    }
  
}

extension UIColor {
    
    class var baseCell: UIColor { return UIColor(hex: 0xf9f9f4)! }
    class var seeMore: UIColor { return UIColor(hex: 0x42bd56)! }

    struct FlatUI {
        // http://flatuicolors.com.
        
        /// SwifterSwift: hex #1ABC9C
        public static let turquoise             = UIColor(hex: 0x1abc9c)!
        
        /// SwifterSwift: hex #16A085
        public static let greenSea              = UIColor(hex: 0x16a085)!
        
        /// SwifterSwift: hex #2ECC71
        public static let emerald               = UIColor(hex: 0x2ecc71)!
        
        /// SwifterSwift: hex #27AE60
        public static let nephritis             = UIColor(hex: 0x27ae60)!
        
        /// SwifterSwift: hex #3498DB
        public static let peterRiver            = UIColor(hex: 0x3498db)!
        
        /// SwifterSwift: hex #2980B9
        public static let belizeHole            = UIColor(hex: 0x2980b9)!
        
        /// SwifterSwift: hex #9B59B6
        public static let amethyst              = UIColor(hex: 0x9b59b6)!
        
        /// SwifterSwift: hex #8E44AD
        public static let wisteria              = UIColor(hex: 0x8e44ad)!
        
        /// SwifterSwift: hex #34495E
        public static let wetAsphalt            = UIColor(hex: 0x34495e)!
        
        /// SwifterSwift: hex #2C3E50
        public static let midnightBlue          = UIColor(hex: 0x2c3e50)!
        
        /// SwifterSwift: hex #F1C40F
        public static let sunFlower             = UIColor(hex: 0xf1c40f)!
        
        /// SwifterSwift: hex #F39C12
        public static let flatOrange            = UIColor(hex: 0xf39c12)!
        
        /// SwifterSwift: hex #E67E22
        public static let carrot                = UIColor(hex: 0xe67e22)!
        
        /// SwifterSwift: hex #D35400
        public static let pumkin                = UIColor(hex: 0xd35400)!
        
        /// SwifterSwift: hex #E74C3C
        public static let alizarin              = UIColor(hex: 0xe74c3c)!
        
        /// SwifterSwift: hex #C0392B
        public static let pomegranate           = UIColor(hex: 0xc0392b)!
        
        /// SwifterSwift: hex #ECF0F1
        public static let clouds                = UIColor(hex: 0xecf0f1)!
        
        /// SwifterSwift: hex #BDC3C7
        public static let silver                = UIColor(hex: 0xbdc3c7)!
        
        /// SwifterSwift: hex #7F8C8D
        public static let asbestos              = UIColor(hex: 0x7f8c8d)!
        
        /// SwifterSwift: hex #95A5A6
        public static let concerte              = UIColor(hex: 0x95a5a6)!
    }
    
}
