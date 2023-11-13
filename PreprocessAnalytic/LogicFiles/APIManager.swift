//
//  APIManager.swift
//  PreprocessAnalytic
//
//  Created by Roushil Singla on 09/11/23.
//

import Foundation

class APIManager {
    
    var refreshToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbl90eXBlIjoiYWNjZXNzIiwiZXhwIjoxNzMwNDEwMjI3LCJpYXQiOjE2OTg4NzQyMjcsImp0aSI6ImQxOGNkZDkyMDg2NDRhMzI5NDIxMWM5YmIxNGMwOWU0IiwidXNlcl9pZCI6MTAsIndvcmtzcGFjZSI6IlJpZmEiLCJ1c2VybmFtZSI6InNhbWVlckByaWZhLm9uZSIsImFjY291bnRfaWQiOjEzLCJsYXN0X3RpbWVzdGFtcCI6IiIsImFjY291bnRfdXVpZCI6IjA3ZDhkODViLTMxNjAtNDhjZi04Njc1LTYwZThlZmYwZWI4MyJ9.gncDoX7P4kfsvU02BlcquQLw0YmpxCYK8hFpTvswYOM"
    
    typealias Handler = (Data?, URLResponse?, Error?) -> Void

    var dataTask: URLSessionDataTask?
    
    func request(endPoint: EndPointType, params: [String: AnyHashable] = [:], appendingURLPath: String = "", completion: @escaping Handler) {
        
        dataTask?.cancel()
        
        let urlPath = endPoint.path + appendingURLPath
        guard let url = URL(string: endPoint.baseURL + urlPath) else { return  }
        var request = URLRequest(url: url)
        request.httpMethod = endPoint.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        
        if endPoint.method == .post {
            request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        }
        
        dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        
        dataTask?.resume()
    }

}
