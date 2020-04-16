//
//  SignUpViewProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/16.
//

import Foundation

public protocol SignUpViewProtocol: class {
    func readyForNavigation()
    func navigateToAlbumsScreen()
    func displayError(error: String)
}
