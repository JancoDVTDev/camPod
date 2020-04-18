//
//  camshareAPIRequest.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/08.
//

import Foundation

struct camshareAPIRequest {
    var request: String
    var resourceURL: URL
    var postRequest: URLRequest?
    
    init(request: String, type: String, model: TipsAndTricksModel?) {
        self.request = request
        let resourceString = "https://camshareapi.herokuapp.com/\(request)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
        
        if type == "POST" {
            let resourceString = URL(string: "http://localhost:8080/tipsandtricks/\(request)")
            guard let requestURL = resourceString else {fatalError()}
            
            var postRequest = URLRequest(url: requestURL)
            postRequest.httpMethod = "POST"
            
//            let postString =
//            "tipID=\(model?.tipID)&heading=\(model?.heading)&body=\(model?.body)&status=\(model?.status)"
            var parameters = [String: Any]()
            if let model = model {
                parameters = ["tipID": model.tipID, "heading": model.heading, "body": model.body, "status": model.status]
            }
            postRequest.httpBody = parameters.percentEncoded()
            
            self.postRequest = postRequest
        }
    }
        
    func getTipsAndTricks(completion: @escaping (Result<[TipsAndTricksModel], CamShareAPIError>) -> Void) {
        let datatask = URLSession.shared.dataTask(with: resourceURL) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.noDataAvailable))
            }
            
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let tipsAndTricksResult = try decoder.decode(TipsAndTricksResult.self, from: jsonData)
                let tipsAndTricks = tipsAndTricksResult.tips
                completion(.success(tipsAndTricks))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        datatask.resume()
    }
    
    func changeStatus(completion: @escaping (Result<TipsAndTricksModel,CamShareAPIError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: postRequest!) { (data, response, error) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let testData = data, let dataString = String(data: data!, encoding: .utf8) {
                print(dataString)
            }
            
            do {
                let decoder = JSONDecoder()
                let tipsAndTricksSingleResult = try decoder.decode(TipsAndTricksSingleResult.self, from: jsonData)
                let tipsAndTricks = tipsAndTricksSingleResult.tips
                completion(.success(tipsAndTricks))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
