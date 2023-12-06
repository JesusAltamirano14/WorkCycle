//
//  ExtensionColor.swift
//  WorkCycle
//
//  Created by Jesus Dario Altamirano Barzola on 6/12/23.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if hexString.hasPrefix("#") {
            scanner.currentIndex = hexString.index(after: hexString.startIndex)
        }

        var color: UInt64 = 0
        scanner.scanHexInt64(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = Double(r) / 255.0
        let green = Double(g) / 255.0
        let blue  = Double(b) / 255.0

        self.init(red: red, green: green, blue: blue)
    }
    
    func disminute() -> Color{
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let color: Color = Color(red: Double((red - 0.05)*255), green: Double((green - 0.1)*255), blue: Double((blue - 0.05)*255))
        return color
    }
    
    func toHex() -> String? {
        let uiColor = UIColor(self)
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        let hexColor = String(format: "#%02X%02X%02X", Int(red*255), Int(green*255), Int(blue*255))
        return hexColor
        
    }
}
