//
//  LoginViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation

public class LoginViewModel {

    public weak var view: LoginViewProtocol?
    public var repo: LoginDataSourceProtocol?

    public init() { }

    public func login(email: String, password: String) {
        repo?.login(email: email, password: password, { (error, signedIn) in
            if signedIn {
                self.view?.readyForNavigation()
                self.view?.navigateToAlbumsScreen()
            } else {
                self.view?.displayError(error: error!)
            }
        })
    }
}
