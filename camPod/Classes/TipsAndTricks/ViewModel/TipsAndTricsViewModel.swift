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
    
    public init() {
        
    }
    
    public func loadTipsAndTricks() {
        getRepo?.fetchTipsAndTricks({ (content, error) in
            if let error = error {
                self.view?.didFinishLoading()
                self.view?.displayError(error: error)
            } else {
                self.view?.updateTableViewCardsSource(content: content!)
                self.view?.didFinishLoading()
                self.view?.reloadTableView()
            }
        })
    }
    
    public func loadYouTubeVideos() {
        
    }

    public func getTipsTricks(request: String, completion: @escaping (_ model: [TipsAndTricksModel]) -> Void) {
        let apiReq = camshareAPIRequest(request: request, type: "GET", model: nil)
        apiReq.getTipsAndTricks { result in
            switch result {
            case .success(let finalResult):
                completion(finalResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    public func changeStatus(status: String, model: TipsAndTricksModel,
                             completion: @escaping (_ model: TipsAndTricksModel) -> Void) {
        let requestString = "tipsandtricks/" + status
        let apiPostReq = camshareAPIRequest(request: requestString, type: "POST", model: model)
        apiPostReq.changeStatus { result in
            switch result {
            case .success(let finalResult):
                completion(finalResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
