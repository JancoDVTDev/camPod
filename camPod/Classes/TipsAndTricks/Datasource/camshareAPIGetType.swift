//
//  camshareAPIGetProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/18.
//

import Foundation

public protocol camshareAPIGetType: class {
    func fetchTipsAndTricks(_ completion: @escaping (_ content: [TipsAndTricksModel]?,_ error: String?) -> Void)
}
