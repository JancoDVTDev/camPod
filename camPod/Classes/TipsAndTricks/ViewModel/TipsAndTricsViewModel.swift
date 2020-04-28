//
//  TipsAndTricsViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/08.
//

import Foundation

public class TipsAndTricsViewModel {

    public weak var view: TipsAndTricksViewType?
    public var getRepo: camshareAPIGetType?
    public var postRepo: CamShareAPIPostType?
    public var youtubeRepo: YoutubeDataAPIType?

    public init() {
        
    }

    public func loadTipsAndTricks() {
        getRepo?.fetchTipsAndTricks({ (content, error) in
            if let error = error {
                self.view?.didFinishLoading()
                self.view?.displayError(error: error)
            } else {
                self.view?.updateTableViewCardsSource(content: content!)
                self.postRepo?.postRating(ratingID: 11, rating: 3, { (ratings, error) in
                    if let error = error {
                        self.view?.displayError(error: error)
                    } else {
                        self.view?.updateRatings(ratings: ratings!)
                        self.view?.didFinishLoading()
                        self.view?.reloadTableView()
                    }
                })
                
            }
        })
    }

    public func updateRating(ratingID: Int, rating: Int) {
        postRepo?.postRating(ratingID: ratingID, rating: rating, { (_, error) in
            if let error = error {
                self.view?.displayError(error: error)
            }
        })
    }

    public func fetchVideosFromYoutube() {
        var snippets = [SnippetModel]()
        var IDs = [IDModel]()
        var youtubeTipsModels = [YoutubeTipsModel]()
        youtubeRepo?.fetchYoutubeTips({ (youtubeResult, error) in
            if let error = error {
                self.view?.displayError(error: error)
            } else {
                for count in 0..<youtubeResult!.count {
                    snippets.append(youtubeResult![count].snippet)
                    IDs.append(youtubeResult![count].id)
                    youtubeTipsModels.append(YoutubeTipsModel(title: snippets[count].title,
                                                              channeId: snippets[count].channelId,
                                                              kind: IDs[count].kind,
                                                              videoId: IDs[count].videoId))
                }
                self.view?.updateTableViewYoutubeSource(youtubeTipsModels: youtubeTipsModels)
                self.view?.didFinishLoading()
            }
        })
    }

    public func loadYouTubeVideos() {
        let videoCodes = ["HXIVNdp_SoM", "RAZtIIe-XHs", "dFz5E1rZqR4",
        "GFy4jb51kQ", "KfVG_2n-iTM", "QxXtdhfprts", "FeaDZj_Nv_g", "OldTVOQPg78"]
        
        self.view?.updateTableViewVideosSource(videoCodes: videoCodes)
    }
}
