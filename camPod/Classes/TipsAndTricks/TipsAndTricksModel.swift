//
//  TipsAndTricksModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/08.
//

import Foundation

public struct TipsAndTricksModel: Decodable {
    public var body: String
    public var status: String
    public var tipID: Int
    public var heading: String
}

public struct TipsAndTricksSingleResult: Decodable {
    var tips : TipsAndTricksModel
}

public struct TipsAndTricksResult: Decodable {
    var tips: [TipsAndTricksModel]
}

