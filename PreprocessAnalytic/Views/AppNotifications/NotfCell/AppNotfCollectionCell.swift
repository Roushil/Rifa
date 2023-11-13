//
//  AppNotfCollectionCell.swift
//  Rifa
//
//  Created by Roushil singla on 11/4/20.
//  Copyright © 2020 personal. All rights reserved.
//

import Cocoa

class AppNotfCollectionCell: NSCollectionViewItem {
    
    
    @IBOutlet weak var badgeView: NSView!
    @IBOutlet weak var badgeLabel: NSTextField!
    @IBOutlet weak var visualEffectView: NSVisualEffectView!
    @IBOutlet weak var appImageView: NSImageView!
    
    var notification: Notifications? {
        didSet {
            configureCell()
        }
    }
    
    public override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "AppNotfCollectionCell", bundle: Bundle(for: AppNotfCollectionCell.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "AppNotfCollectionCell", bundle: Bundle(for: AppNotfCollectionCell.self))
    }

    override func mouseDragged(with event: NSEvent) {
        view.window?.performDrag(with: event)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        badgeView.wantsLayer = true
        badgeView.layer?.cornerRadius = badgeView.frame.height/2
        badgeView.layer?.backgroundColor = NSColor.systemRed.cgColor
        
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 10
        
    }
    
    
    private func configureCell() {
        appImageView.image = NSImage(named: notification?.appName ?? "")
        badgeLabel.stringValue = String(notification?.badgeValue ?? 0)
    }
    
}
