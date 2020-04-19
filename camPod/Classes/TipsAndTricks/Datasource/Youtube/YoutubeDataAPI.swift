//
//  YoutubeDataAPI.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/19.
//

import Foundation

public class YoutubeDataAPI: YoutubeDataAPIType {
    
    var requestURL: URL
    
    public init() {

        let part = "snippet"
        let publishedAfter = "2020-01-01T00:00:00Z"
        let q = "iphone camera tips"
        let key = "AIzaSyCtyLwfA3Rv0PHisY8WJnJEuVxcv76AQUA"
        
        let queryParams: [String: String] = [
            "part": "snippet",
            "publishedAfter": "2020-01-01T00%3A00%3A00Z",
            "q": "iphone camera tips",
            "key": "AIzaSyCtyLwfA3Rv0PHisY8WJnJEuVxcv76AQUA"
        ]
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "www.googleapis.com"
        urlComponents.path = "/youtube/v3/search"
        urlComponents.queryItems = [
            URLQueryItem(name: "part", value: part),
            URLQueryItem(name: "publishedAfter", value: publishedAfter),
            URLQueryItem(name: "q", value: q),
            URLQueryItem(name: "key", value: key)
        ]
        
        print(urlComponents.url?.absoluteString)
        
        guard let requestURL = urlComponents.url?.absoluteURL else {fatalError()}
        
        self.requestURL = requestURL
    }
    
    public func fetchYoutubeTips(_ completion: @escaping ([ItemModel]?, String?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: requestURL) {data , response, error in
            if let error = error {
                completion(nil,error.localizedDescription)
            } else {
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(YoutubeResult.self, from: jsonData)
                        let resultModel = result.items
                        completion(resultModel, nil)
                    } catch {
                        completion(nil, "Cannot process data")
                    }
                } else {
                    completion(nil, "No data available")
                }
            }
        }
        dataTask.resume()
    }
}

extension URLComponents {
    mutating func setQueryItems(with parameters: [String: String]) {
        self.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
}
