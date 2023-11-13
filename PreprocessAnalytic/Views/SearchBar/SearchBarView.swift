//
//  SearchBarView.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 04/11/23.
//

import Cocoa

enum SearchBarPurpose {
    case query
    case conversation
}

protocol SearchBarDelegate: AnyObject {
    func onSearchClick()
    func onBackClick()
    func onLogoClick()
    func onTextChange(text: String)
}

class SearchBarView: NSView {

    @IBOutlet var customView: NSView!
    @IBOutlet weak var backButton: NSButton!
    @IBOutlet weak var logoButton: NSButton!
    @IBOutlet weak var userQueryField: NSTextField!
    
    var barPurpose: SearchBarPurpose = .query {
        didSet {
            if barPurpose == .query {
                userQueryField.stringValue = ""
            }
            //userQueryField.placeholderString = barPurpose == .query ? UserInfo.placeholder : "Type your message"
            updateButtons()
        }
    }
    
    var searchedQuery: String {
        get {
            userQueryField.stringValue
        }
    }
    
    weak var delegate: SearchBarDelegate?
    
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
        
    }
    
    @IBAction func onLogoClick(_ sender: NSButton) {
        delegate?.onLogoClick()
    }
    
    @IBAction func onBackClick(_ sender: NSButton) {
        barPurpose = .query
        delegate?.onBackClick()
    }
    
    
    @IBAction func onSearchClick(_ sender: NSButton) {
        if !userQueryField.stringValue.isEmpty {
            //userQueryField.stringValue = ""
            delegate?.onSearchClick()
        }
    }
    
    private func addView() {
        Bundle(for: SearchBarView.self).loadNibNamed("SearchBarView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        customView.frame = contentFrame
        addSubview(customView)
    }
    
    private func setupView() {
        addView()
        barPurpose = .query
        userQueryField.delegate = self
    }
    
    private func updateButtons() {
        logoButton.isHidden = barPurpose == .conversation
        backButton.isHidden = barPurpose == .query
    }
    
    public func updatePlaceholder() {
        userQueryField.placeholderString = UserInfo.placeholder
    }
    
    public func updateText(text: String) {
        userQueryField.stringValue = text
    }
}

extension SearchBarView: NSTextFieldDelegate {
    
    func controlTextDidChange(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        delegate?.onTextChange(text: textField.stringValue)
    }
    
}
