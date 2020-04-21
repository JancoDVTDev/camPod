//
//  SavedImagesType.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/21.
//

import Foundation
import CoreData

public protocol SavedImagesType: class {
    func returnContainer() -> NSPersistentContainer
}
