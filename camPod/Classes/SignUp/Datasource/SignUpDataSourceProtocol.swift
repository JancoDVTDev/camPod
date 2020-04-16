//
//  SignUpDataSourceProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation

public protocol SignUpDataSourceProtocol: class {
    func signUp(firstName: String, lastName: String, email: String, password: String,
                _ completion: @escaping (_ error: String?,_ signedUp: Bool) -> Void)
}
