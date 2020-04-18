//
//  camshareAPIGet.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/18.
//

import Foundation

public class camshareAPIGet: camshareAPIGetType {
    
    var resourceURL: URL
    
    public init() {
        let resourceString = "https://camshareapi.herokuapp.com/tipsandtricks"
        guard let resourceURL = URL(string: resourceString) else {fatalError()}
        self.resourceURL = resourceURL
    }
    
    public func fetchTipsAndTricks(_ completion: @escaping (_ content: [TipsAndTricksModel]?,_ error: String?) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil,error.localizedDescription)
            } else {
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        let contentResult = try decoder.decode(TipsAndTricksResult.self, from: jsonData)
                        let tipsAndTricksModel = contentResult.tips
                        completion(tipsAndTricksModel,nil)
                    } catch {
                        completion(nil, "Data cannot be processed")
                    }
                } else {
                    completion(nil, "Data cannot be processed")
                }
            }
        }
        dataTask.resume()
    }
}
