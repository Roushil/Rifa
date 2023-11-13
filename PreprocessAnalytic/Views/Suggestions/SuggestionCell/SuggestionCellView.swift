//
//  SuggestionCellView.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 05/11/23.
//

import Cocoa

class SuggestionCellView: NSTableCellView {

    @IBOutlet weak var highlightView: NSView!
    @IBOutlet weak var appIconImageView: NSImageView!
    @IBOutlet weak var appNameField: NSTextField!
    @IBOutlet weak var appDescriptionField: NSTextField!
    
    var suggestion: Suggestions? {
        didSet {
            configure()
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        highlightView.wantsLayer = true
        highlightView.layer?.cornerRadius = 8
        self.addTrackingArea(NSTrackingArea(rect: self.bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil))
    }
 
    public override func mouseEntered(with event: NSEvent) {
        highlightView.layer?.backgroundColor = suggestion?.isSelected == true ? NSColor.lightGray.withAlphaComponent(0.2).cgColor : NSColor.lightGray.withAlphaComponent(0.1).cgColor
    }
    
    public override func mouseExited(with event: NSEvent) {
        highlightView.layer?.backgroundColor = suggestion?.isSelected == true ? NSColor.lightGray.withAlphaComponent(0.2).cgColor : NSColor.clear.cgColor
    }
    
    private func configure() {
        //appIconImageView.image = NSImage(named: suggestion?.appImage ?? "")
        appNameField.stringValue = suggestion?.name ?? ""
        appDescriptionField.stringValue = suggestion?.text ?? ""
        highlightView.layer?.backgroundColor = suggestion?.isSelected == true ? NSColor.lightGray.withAlphaComponent(0.2).cgColor : NSColor.clear.cgColor
    }
}
