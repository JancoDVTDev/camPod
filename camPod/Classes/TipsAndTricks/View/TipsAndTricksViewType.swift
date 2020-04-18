//
//  TipsAndTricksViewProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/18.
//

import Foundation

public protocol TipsAndTricksViewType: class {
    func updateTableViewCardsSource(content: [TipsAndTricksModel])
    func didFinishLoading()
    func displayError(error: String)
    func reloadTableView()
}
