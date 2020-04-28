//
//  camshareAPIPostType.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/28.
//

import Foundation

public protocol CamShareAPIPostType: class {
    func postRating(ratingID: Int, rating: Int,
    _ completion: @escaping (_ ratings: [RatingModel]?, _ error: String?) -> Void)
}
