//
//  YoutubeDataAPIType.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/19.
//

import Foundation

public protocol YoutubeDataAPIType: class {
    func fetchYoutubeTips(_ completion: @escaping (_ items: [ItemModel]?,_ error: String?) -> Void)
}
