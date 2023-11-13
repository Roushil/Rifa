//
//  AppConstant.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 05/11/23.
//

import Foundation

struct AppSize {
    
    private init() { }
    
    static let appMaxHeight: Int = 700
    static let appMaxWidth: Int = 700
    
    //MARK: Handle view size states according to maximum app size above
    
    static let suggestionViewHeight: CGFloat = 370
    static let resultViewHeight: CGFloat = 600
    
}

struct UserInfo {
    
    private init() { }
    
    static var placeholder = "What can we do for you today?"
}
