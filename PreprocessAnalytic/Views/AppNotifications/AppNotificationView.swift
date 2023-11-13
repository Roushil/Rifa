//
//  AppNotificationView.swift
//  Rifa
//
//  Created by Roushil Singla on 04/11/23.
//

import Cocoa

protocol AppNotificationDelegate: AnyObject {
    func onClearClick()
}

class AppNotificationView: NSView {

    @IBOutlet var customView: NSView!
    @IBOutlet weak var notfCollectionView: NSCollectionView!
    @IBOutlet weak var collectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var clearButton: NSButton!
    
    weak var delegate: AppNotificationDelegate?
    
    var notifications: [Notifications] = []
    
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
        setCollectionSize()
        clearButton.wantsLayer = true
        clearButton.layer?.backgroundColor = NSColor.lightGray.withAlphaComponent(0.4).cgColor
        clearButton.layer?.cornerRadius = clearButton.frame.height/2
    }
    
    
    @IBAction func onClearClick(_ sender: NSButton) {
        delegate?.onClearClick()
    }
    
    
    private func addView() {
        Bundle(for: AppNotificationView.self).loadNibNamed("AppNotificationView", owner: self, topLevelObjects: nil)
        let contentFrame = NSMakeRect(0, 0, frame.size.width, frame.size.height)
        customView.frame = contentFrame
        addSubview(customView)
    }
    
    
    private func registerForCells() {
        notfCollectionView.dataSource = self
        notfCollectionView.delegate = self
    }
    
    private func setupView() {
        addView()
        registerForCells()
    }
    
    public func updateNotifications(notification: [Notifications]) {
        self.notifications = notification
        notfCollectionView.reloadData()
        setCollectionSize()
    }
    
    private func setCollectionSize() {
        let width = notfCollectionView.collectionViewLayout?.collectionViewContentSize.width
        collectionViewWidth.constant = width ?? 45
        notfCollectionView.collectionViewLayout?.invalidateLayout()
        
    }
}

extension AppNotificationView: NSCollectionViewDataSource, NSCollectionViewDelegate {
    
    public func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        return notifications.count
    }
    
    public func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "AppNotfCollectionCell"), for: indexPath)
        guard let dotItem = item as? AppNotfCollectionCell else { return item }
        dotItem.notification = notifications[indexPath.item]
        return dotItem
    }

}
