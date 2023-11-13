//
//  LogicWorker.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 10/11/23.
//

import Foundation

protocol QueryResultDelegate {
    func responeOfQuery(string: String)
}

class LogicWorker {
    
    private init() { }
    
    private var apiManager = APIManager()
    
    private static var sharedInstance: LogicWorker?
    
    class var shared: LogicWorker {
        guard let sharedInstance = self.sharedInstance else {
            let sharedInstance   = LogicWorker()
            self.sharedInstance  = sharedInstance
            return sharedInstance
        }
        return sharedInstance
    }
    
    class func destroySingletonInstance() {
        sharedInstance = nil
    }
    
    
    func requestProfile(completion: @escaping (Result<WelcomeModel?, Error>) -> Void?) {
        
        apiManager.request(endPoint: EndPointItems.userProfile) { [weak self] data, _, error in
            guard let _self = self, let data = data, error == nil else { return }

            do {
                let response = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                guard let strData = (response?["data"] as? String),
                      let data = strData.data(using: .utf8),
                      let finalResponse = try? JSONSerialization.jsonObject(with: data)
                else { return }
                
                let dict = finalResponse as? NSDictionary
                completion(.success(_self.parseUserProfile(dict: dict)))
                
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    
    func searchQuery(delegate: QueryResultDelegate?, text: String) {
        let params = [
            "query_string": text
        ]
        apiManager.request(endPoint: EndPointItems.search, params: params) { [weak self] data, _, error in
            guard let _self = self, let data = data, error == nil else { return }
            do {
                let response = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                print(response ?? NSDictionary())
                _self.getSearchResults(delegate: delegate)
                
            } catch {
                print(error.localizedDescription)
                // need to handle timeout
                // need to handle no internet connection
            }
        }
    }
    
    private func getSearchResults(delegate: QueryResultDelegate?) {
        
        apiManager.request(endPoint: EndPointItems.searchResults) { [weak self] data, response, error in
            guard let _self = self, let data = data, error == nil else { return }
            
            do {
                let response = try JSONSerialization.jsonObject(with: data) as? NSDictionary
                let dict = response?["data"] as? NSDictionary
                let retry = dict?["retry"] as? Bool
                if retry == true {
                    DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) {
                        _self.getSearchResults(delegate: delegate)
                    }
                } else {
                    let message = (dict?["message"] as? String)
                    delegate?.responeOfQuery(string: message ?? "")
                }
            } catch {
                print(error.localizedDescription)
                // need to handle timeout
                // need to handle no internet connection
            }
        }
    }
}


extension LogicWorker {
    
    private func parseUserProfile(dict: NSDictionary?) -> WelcomeModel? {
        
        var notificationsModel: [Notifications] = []
        var suggestionsModel: [Suggestions] = []
        
        
        if let suggestions = dict?["suggestions"] as? [String: Any] {
            for (key, value) in suggestions {
                let valueDict = value as? NSDictionary
                suggestionsModel.append(Suggestions(name: key, text: valueDict?["text"] as? String, execute: valueDict?["execute"] as? Bool))
            }
        }
        
        if let notifications = dict?["notifications"] as? [String: Int] {
            for (key, value) in notifications {
                notificationsModel.append(Notifications(appName: key, badgeValue: value))
            }
        }
        
        return WelcomeModel(placeholder: dict?["placeholder_text"] as? String,
                                    threadID: dict?["thread_id"] as? String,
                                    suggestions: suggestionsModel,
                                    notifications: notificationsModel)
    }
    
    
}
