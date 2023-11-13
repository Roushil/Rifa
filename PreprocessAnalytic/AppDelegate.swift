//
//  AppDelegate.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 03/10/23.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {

    private var windowController: NSWindowController!
    private var statusItem: NSStatusItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        prepareWindow()
        prepareAppMenu()
    }

    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        LogicWorker.destroySingletonInstance()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}


extension AppDelegate {
    
    func prepareWindow() {
        
        windowController = NSWindowController(window: NSWindow(contentViewController: AnalyticSearchController()))
        
        /// Make the application the main application.
        NSApp.activate(ignoringOtherApps: true)
        
        /// Center the window.
        windowController.window?.center()
        
        windowController.window?.maxSize = NSSize(width: AppSize.appMaxWidth, height: AppSize.appMaxHeight)
        
        /// Make window transparent and let other views handle the display
        windowController.window?.isOpaque = false
        windowController.window?.backgroundColor = .clear

        /// Open the window.
        windowController.window?.makeKeyAndOrderFront(nil)

        /// The titled style mask needs to be removed after the window ordered the front
        windowController.window?.styleMask.remove(.titled)
    }
    
    func prepareAppMenu() {
        
        let menu = NSMenu()
        
        //let displayItem = NSMenuItem(title: "Display App", action: #selector(displayItem), keyEquivalent: "")
        //menu.addItem(displayItem)
        
        let quickStartItem = NSMenuItem(title: "Quick Start", action: #selector(quickURL), keyEquivalent: "")
        menu.addItem(quickStartItem)
        

        menu.addItem(NSMenuItem.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(teardown), keyEquivalent: "")
        menu.addItem(quitItem)

        self.statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.statusItem?.menu = menu
        self.statusItem?.button?.image = NSImage(systemSymbolName: "lasso", accessibilityDescription: "")
    }
    
    @objc func displayItem() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    @objc func quickURL() {
        NSWorkspace.shared.open(URL(string: "https://planet-seaplane-93a.notion.site/How-to-use-PreProcess-bce91ac25f7d4ba9bdeb1ff453f4ee9c")!)
    }
    
    @objc func teardown() {
        NSApplication.shared.terminate(nil)
    }
}
