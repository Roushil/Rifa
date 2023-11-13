//
//  CustomAlert.swift
//  Oasis
//
//  Created by Nikhil Narayan on 13/08/21.
//

import Foundation
import Cocoa

public class CustomAlert {
    
    public init() {}
    
    let loaderViewObj = AlertView()
    
    public func showLoader(view: NSView, message: String = "") {
        view.addSubview(loaderViewObj)
        loaderViewObj.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loaderViewObj.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            loaderViewObj.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            loaderViewObj.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            loaderViewObj.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: 0)
        ])
        loaderViewObj.wantsLayer = true
        loaderViewObj.layer?.cornerRadius = 7
        loaderViewObj.showMessage(message)
        loaderViewObj.animateImage()
    }
    
    
    public func removeLoader() {
        DispatchQueue.main.async {
            self.loaderViewObj.removeFromSuperview()
        }
    }
    
}
