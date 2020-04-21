//
//  LoginDataSourceProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation

public protocol LoginDataSourceProtocol: class {
    func login(email: String, password: String, _ completion: @escaping (_ error: String?, _ signedIn: Bool) -> Void)
}
