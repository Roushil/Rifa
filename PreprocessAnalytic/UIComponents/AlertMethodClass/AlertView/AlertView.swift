//
//  AlertView.swift
//  adjustlogo
//
//  Created by Roushil singla on 10/8/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa


class AlertView: NSView {

    
    @IBOutlet weak var customView: NSView!
    @IBOutlet weak var alertImageView: NSImageView!
    @IBOutlet weak var messageField: NSTextField!
    
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
    }
    
    public override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        addView()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        addView()
    }
    
    private func addView() {
        Bundle(for: AlertView.self).loadNibNamed("AlertView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        customView.frame = contentFrame
        addSubview(customView)
    }
    
    func showMessage(_ text: String) {
        messageField.stringValue = text
    }
    
    func animateImage() {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = 1
        animation.toValue = 0
        animation.autoreverses = true
        animation.duration = 1
        animation.repeatCount = .infinity
        alertImageView.wantsLayer = true
        alertImageView.layer?.add(animation, forKey: nil)
    }
}
