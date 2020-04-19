//
//  YoutubeTipsModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/19.
//

import Foundation

public class YoutubeTipsModel {
    public var title: String
    public var channeId: String
    public var kind: String
    public var videoId: String
    
    public init(title: String, channeId: String, kind: String, videoId: String) {
        self.title = title
        self.channeId = channeId
        self.kind = kind
        self.videoId = videoId
    }
}

public struct IDModel: Decodable {
    var kind: String
    var videoId: String
}

public struct SnippetModel: Decodable {
    var title: String
    var channelId: String
}

public struct ItemModel: Decodable {
    var id: IDModel
    var snippet: SnippetModel
}

public struct YoutubeResult: Decodable {
    var items: [ItemModel]
}
