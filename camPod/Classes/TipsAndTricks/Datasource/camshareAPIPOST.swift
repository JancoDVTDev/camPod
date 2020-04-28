//
//  camshareAPIPOST.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/28.
//

import Foundation

public class CamshareAPIPOST: CamShareAPIPostType {

    public init() {

    }

    func createRequestURL(ratingID: Int, rating: Int) -> URLRequest? {
        let baseURL = "https://camshareapi.herokuapp.com/rating"
        guard let requestURL = URL(string: baseURL) else {return nil}
        var postRequest = URLRequest(url: requestURL)
        postRequest.httpMethod = "POST"
        let parameters: [String: Int] = [
            "ratingID": ratingID,
            "rating": ratingID
        ]
        postRequest.httpBody = parameters.percentEncoded()
        return postRequest
    }

    public func postRating(ratingID: Int, rating: Int,
                             _ completion: @escaping (_ ratings: [RatingModel]?, _ error: String?) -> Void) {
        let requestURL = createRequestURL(ratingID: ratingID, rating: rating)!
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in
            if let error = error {
                completion(nil, error.localizedDescription)
            } else {
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        let ratingResult = try decoder.decode(Ratings.self, from: jsonData)
                        let ratings = ratingResult.ratings
                        completion(ratings, nil)
                    } catch {
                        completion(nil, "Cannot Process Data")
                    }
                } else {
                    completion(nil, "No Data available")
                }
            }
        }
        dataTask.resume()
    }
}
extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters:
                .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters:
                .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}
extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
