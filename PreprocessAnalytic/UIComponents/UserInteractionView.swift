//
//  UserInteractionView.swift
//  adjustlogo
//
//  Created by Roushil singla on 10/12/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa

public class UserInteractionView: NSView {
    
    public var isUserInteractionEnabled = true
    
    public override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
    /* Set User Interaction for View */
    public override func hitTest(_ point: NSPoint) -> NSView? {
        return self.isUserInteractionEnabled ? super.hitTest(point) : nil
    }
    
}
