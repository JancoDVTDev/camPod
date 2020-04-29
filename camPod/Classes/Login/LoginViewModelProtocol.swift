//
//  LoginViewModelProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/29.
//

import Foundation

public protocol LoginViewModelProtocol {
    var repo: LoginDataSourceProtocol? { get set}
    func login(email: String, password: String) 
}
