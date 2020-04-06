//
//  APICall.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/03.
//

import Foundation

public enum CamShareAPIError: Error {
    case noDataAvailable
    case cannotProcessData
}

public struct APICall {
    let resourceURL: URL
    var request: String
    let postRequest: URLRequest

    init (request: String) {
        self.request = request
        let resourceString = "http://localhost:8080/validate/\(request)"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
        
        // For initializer
        self.postRequest = URLRequest(url: URL(string: "http://www.tamper.com")!)
    }
    
    init (post name: String,with surname: String) {
        let resourceString = URL(string: "http://localhost:8080/user/")
        guard let requestURL = resourceString else {fatalError()}
        
        var postRequest = URLRequest(url: requestURL)
        postRequest.httpMethod = "POST"
        
        let postString = "name=\(name)&surname=\(surname)"
        
        postRequest.httpBody = postString.data(using: String.Encoding.utf8)
        
        self.postRequest = postRequest
        
        // For init
        self.request = ""
        self.resourceURL = URL(string: "http://www.tamper.com")!
    }
    
    func validateEmail(completion: @escaping (Result<String, CamShareAPIError>) -> Void) { //Result<[ValidationInfo], CamShareAPIError>
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { (data, _, _) in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            if let testData = data, let dataString = String(data: data!, encoding: .utf8) {
                print(dataString)
            }
                        
            do {
                let decoder = JSONDecoder()
                let validationResponse = try decoder.decode(ValidationResult.self, from: jsonData)
                let validationInfo = validationResponse.Error
                completion(.success(validationInfo))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
    
    func postFunctionality(completion: @escaping (Result<WelcomeModel,CamShareAPIError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: postRequest) { (data, response, error) in
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
                let welcomeResponse = try decoder.decode(WelcomeResponse.self, from: jsonData)
                let welcomeInfo = welcomeResponse.result
                completion(.success(welcomeInfo))
            } catch {
                completion(.failure(.cannotProcessData))
            }
        }
        dataTask.resume()
    }
}
