//
//  TrackFirebaseAnalytics.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/30.
//

import Foundation

@objc public class TrackFirebaseAnalytics: NSObject {
    public override init () {
        
    }
    public func log(name: String, parameters: [String:Any]?) {
        Analytics.logEvent(name, parameters: parameters)
    }
}
