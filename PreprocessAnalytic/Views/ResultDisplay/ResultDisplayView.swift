//
//  ResultDisplayView.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 06/11/23.
//

import Cocoa

class ResultDisplayView: NSView {

    @IBOutlet var customView: NSView!
    @IBOutlet weak var displayView: NSView!
    @IBOutlet weak var outputTextField: NSTextField!
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        displayView.wantsLayer = true
        displayView.layer?.cornerRadius = 7
        displayView.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.2).cgColor
    }
    
    private func addView() {
        Bundle(for: ResultDisplayView.self).loadNibNamed("ResultDisplayView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        customView.frame = contentFrame
        addSubview(customView)
    }
    
    private func setupView() {
        addView()
    }
    
    public func displayResult(text: String) {
        outputTextField.stringValue = text
    }
}
