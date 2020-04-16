//
//  SignUpViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation

public class SignUpViewModel {
    public weak var view: SignUpViewProtocol?
    public var repo: SignUpDataSourceProtocol?
    
    public init() { }
    
    public func signUp(firstName: String, lastName: String, email: String, password: String) {
        repo?.signUp(firstName: firstName, lastName: lastName, email: email, password: password, { (error, signedUp) in
            if signedUp {
                self.view?.readyForNavigation()
                self.view?.navigateToAlbumsScreen()
            } else {
                self.view?.displayError(error: error!)
            }
        })
    }
    
    public func validateFields(firstName: String, lastName: String, email: String, password: String) -> Bool {

        if firstName  == "" || lastName  == "" || email == "" || password == "" {
            self.view?.displayError(error: "Please fill in all fields")
            return false
        }
        
        let helpingHand = ObjcHelper()
        let valid = helpingHand.validateLoginFields(email, password)
        let errorMessage = helpingHand.getLoginErrorMessage(email, password)
        if  !(valid) {
            self.view?.displayError(error: errorMessage!)
            return false
        }
        return true
    }
}
