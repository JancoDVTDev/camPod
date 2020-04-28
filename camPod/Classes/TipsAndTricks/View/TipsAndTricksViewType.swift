//
//  TipsAndTricksViewProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/18.
//

import Foundation

public protocol TipsAndTricksViewType: class {
    func updateTableViewCardsSource(content: [TipsAndTricksModel])
    func updateTableViewVideosSource(videoCodes: [String])
    func updateTableViewYoutubeSource(youtubeTipsModels: [YoutubeTipsModel])
    func updateRatings(ratings: [RatingModel])
    func didFinishLoading()
    func displayError(error: String)
    func reloadTableView()
}
