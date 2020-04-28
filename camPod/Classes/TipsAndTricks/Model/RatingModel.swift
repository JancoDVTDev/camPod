//
//  RatingModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/28.
//

import Foundation

public struct Ratings: Decodable {
    public var ratings: [RatingModel]
}

public struct RatingModel: Decodable {
    public var ratingID: Int
    public var lastRating: Int
    public var veryBadNumberOfRatings: Int
    public var badNumberOfRatings: Int
    public var okayNumberOfRatings: Int
    public var goodNumberOfRatings: Int
    public var veryGoodNumberOfRatings: Int
    public var overallRating: Int
}
