//
//  LoginViewProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation

public protocol LoginViewProtocol: class {
    func readyForNavigation()
    func navigateToAlbumsScreen()
    func displayError(error: String)
}
