//
//  Models.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 09/11/23.
//

import Foundation

struct WelcomeModel {
    
    var placeholder: String?
    var threadID: String?
    var suggestions: [Suggestions]
    var notifications: [Notifications]
}

struct Suggestions {
    var name: String?
    var text: String?
    var execute: Bool?
    var isSelected: Bool = false
}

struct Notifications {
    var appName: String?
    var badgeValue: Int?
}
