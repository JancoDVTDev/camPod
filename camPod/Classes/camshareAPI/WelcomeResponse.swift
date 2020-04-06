//
//  WelcomeResponse.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/06.
//

import Foundation

struct WelcomeResponse: Decodable {
    var result: WelcomeModel
}

struct WelcomeModel: Decodable {
    var name: String
    var surname: String
}
