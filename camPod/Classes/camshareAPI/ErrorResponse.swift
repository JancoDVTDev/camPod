//
//  ErrorResponse.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/06.
//

import Foundation

struct ValidationResult: Decodable {
    //var result: [ValidationInfo]
    var Error: String
}

struct ValidationInfo: Decodable {
    var Error: String
    //var Status: String
}
