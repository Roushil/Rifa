//
//  NSExtensions.swift
//  WenoiUI
//
//  Created by Roushil singla on 8/29/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Foundation
import Cocoa


public extension NSAttributedString {
    
    func height(containerWidth: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.height)
    }
    
    func width(containerHeight: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        return ceil(rect.size.width)
    }
}



extension String {
    
    public static var noInternetMessage: Self {
        return "Please check your Internet Connection !"
    }
    
    
    public func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    public var isNumber: Bool {
        return self.allSatisfy { character in
            character.isNumber
        }
    }
    
    ///* Fetch Date From String during the sorting of products from date
    public func fetchDateFromString(format: String?) -> Date {
        
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd"
        let date                 = dateFormatter.date(from: self)
        return date ?? Date()
    }
    
    /// Get NScolor from hex string value
    @available(macOS 10.15, *)
    public var hexColor: NSColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        if #available(iOS 13, *) {
            guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
            
            let a, r, g, b: Int32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            
            return NSColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
            
        } else {
            var int = UInt32()
            
            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            
            return NSColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        }
    }
    
}

extension Date {
    
    ///* Return formatted date in String from Fetched Date */
    public func getFormattedStringFromDate(format: String?) -> String {
        let formatter           = DateFormatter()
        formatter.dateFormat    = format ?? "yyyy-MM-dd"
        let dateString          = formatter.string(from: self)
        return dateString
    }
}

///* Fetch Differnece from Array or list out missed elements
extension Array where Element: Hashable {
    
    public func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}


extension NSViewController {
    
    public func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    public func addView(of module: NSView) {
        view.addSubview(module)
        module.translatesAutoresizingMaskIntoConstraints                        = false
        module.topAnchor.constraint(equalTo: view.topAnchor).isActive           = true
        module.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive   = true
        module.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        module.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive     = true
    }
}

public extension NSView {
    
    func addView(of module: NSView, topConsant: CGFloat = 0, leadingConsant: CGFloat = 0, trailingConsant: CGFloat = 0, bottomConsant: CGFloat = 0) {
        addSubview(module)
        module.translatesAutoresizingMaskIntoConstraints = false
        module.topAnchor.constraint(equalTo: topAnchor, constant: topConsant).isActive = true
        module.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leadingConsant).isActive = true
        module.trailingAnchor.constraint(equalTo: trailingAnchor, constant: trailingConsant).isActive = true
        module.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomConsant).isActive = true
    }
    

    func setBorder(color: NSColor?, width: CGFloat = 1) {
        self.wantsLayer             = true
        self.layer?.cornerRadius    = 5
        self.layer?.borderWidth     = width
        self.layer?.borderColor     = color == nil ? NSColor.darkGray.cgColor : color?.cgColor
    }
    
    func setCircularBorder(cornerRadius: CGFloat? = nil, color: NSColor? = .darkGray) {
        self.wantsLayer             = true
        self.layer?.cornerRadius    = cornerRadius == nil ? self.frame.height/2 : (cornerRadius ?? 5)
        self.layer?.borderColor     = color == nil ? NSColor.darkGray.cgColor : color?.cgColor
        self.layer?.borderWidth     = 1
    }
    
    func addShadow(color: NSColor = NSColor.lightGray.withAlphaComponent(0.8), backgroundColor: NSColor? = nil) {
        self.wantsLayer = true
        if backgroundColor == nil {
            self.layer?.backgroundColor = effectiveAppearance.name == .darkAqua ? .black : .white
        } else {
            self.layer?.backgroundColor = backgroundColor?.cgColor
        }
        self.shadow = NSShadow()
        self.layer?.shadowOpacity = 0.5
        self.layer?.shadowColor = color.cgColor
        self.layer?.shadowOffset = NSMakeSize(2 , -2)
        self.layer?.shadowRadius = 2
    }
}



let imageCache = NSCache<AnyObject, AnyObject>()
public class CacheLoaderImageView: NSImageView {

    private var imageURL: String?

    public func loadImageUsingCache(strImageURL: String) {
        
        let image = strImageURL.replacingOccurrences(of: " ", with: "%20")
        imageURL = image
        self.image = NSImage(named: "default")

        if let cachedImage = imageCache.object(forKey: image as NSString) as? NSImage {
            self.image = cachedImage
            return
        }

        guard let url = URL(string: image) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            DispatchQueue.main.async {
                guard let downloadedImage = NSImage(data: data) else { return }
                if self.imageURL == image {
                    self.image = downloadedImage
                    imageCache.setObject(downloadedImage, forKey: image as NSString)
                }                
            }
        }.resume()
    }
}

public extension NSImage {
    
    func resized(to newSize: CGSize) -> NSImage? {
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        let sourceRect = NSMakeRect(0, 0, size.width, size.height)
        let destRect = NSMakeRect(0, 0, newSize.width, newSize.height)
        draw(in: destRect, from: sourceRect, operation: .sourceOver, fraction: CGFloat(1))
        newImage.unlockFocus()
        return newImage
    }
    
    /* Return Same Image with color applied on it */
    func imageWithColor(tintColor: NSColor) -> NSImage {
        guard isTemplate else { return self }
        guard let copiedImage = self.copy() as? NSImage else { return self }
        copiedImage.lockFocus()
        tintColor.set()
        let imageBounds = NSMakeRect(0, 0, copiedImage.size.width, copiedImage.size.height)
        imageBounds.fill(using: .sourceAtop)
        copiedImage.unlockFocus()
        copiedImage.isTemplate = false
        return copiedImage
    }
    
}

public extension NSColor {

    var hexValue: String {
        
        guard let rgbColor = usingColorSpace(NSColorSpace.deviceRGB) else {
            return "FFFFFF"
        }
        let red = Int(round(rgbColor.redComponent * 0xFF))
        let green = Int(round(rgbColor.greenComponent * 0xFF))
        let blue = Int(round(rgbColor.blueComponent * 0xFF))
        let hexString = NSString(format: "#%02X%02X%02X", red, green, blue)
        return hexString as String
    }

}

public extension NSTableView {
    
    override func rightMouseDown(with event: NSEvent) {
        let globalLocation = event.locationInWindow
        let localLocation = self.convert(globalLocation, from: nil)
        let clickedRow = self.row(at: localLocation)
        super.rightMouseDown(with: event)
        if clickedRow != -1 {
            (self.delegate as? NSTableViewRightClickDelegate)?.tableView(self, didRightClickRow: clickedRow)
        }
    }
}

public protocol NSTableViewRightClickDelegate: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, didRightClickRow row: Int)
}


extension NSButton {

    public func setStyle(with bgColor: NSColor?, tintColor: NSColor? = .labelColor, needCircularBorder: Bool, cornerRadius: CGFloat? = nil) {
        
        self.bezelStyle             = .texturedSquare
        self.wantsLayer             = true
        self.layer?.backgroundColor = bgColor?.cgColor
        if #available(OSX 10.14, *) {
            self.contentTintColor       = tintColor
        } else {
            self.attributedTitle = NSAttributedString(string: self.title, attributes: [NSAttributedString.Key.foregroundColor : tintColor ?? .clear])
        }
        if needCircularBorder {
            self.layer?.cornerRadius = self.frame.height/2
        } else {
            if let cornerRadius = cornerRadius {
                self.layer?.cornerRadius = cornerRadius
            }
        }
    }
    
    
    /* Applying background to Button with color */
    public func setBorder(with color: NSColor?) {
        self.wantsLayer          = true
        self.layer?.borderWidth  = 1
        self.layer?.borderColor  = color?.cgColor
        self.layer?.cornerRadius = 7
    }
}


public extension NSProgressIndicator {

    func set(tintColor: NSColor) {
        guard let adjustedTintColor = tintColor.usingColorSpace(.deviceRGB) else {
            contentFilters = []
            return
        }

        let tintColorRedComponent = adjustedTintColor.redComponent
        let tintColorGreenComponent = adjustedTintColor.greenComponent
        let tintColorBlueComponent = adjustedTintColor.blueComponent

        let tintColorMinComponentsVector = CIVector(x: tintColorRedComponent, y: tintColorGreenComponent, z: tintColorBlueComponent, w: 0.0)
        let tintColorMaxComponentsVector = CIVector(x: tintColorRedComponent, y: tintColorGreenComponent, z: tintColorBlueComponent, w: 1.0)

        let colorClampFilter = CIFilter(name: "CIColorClamp")
        colorClampFilter?.setDefaults()
        colorClampFilter?.setValue(tintColorMinComponentsVector, forKey: "inputMinComponents")
        colorClampFilter?.setValue(tintColorMaxComponentsVector, forKey: "inputMaxComponents")

        contentFilters = [colorClampFilter!]
    }
}
