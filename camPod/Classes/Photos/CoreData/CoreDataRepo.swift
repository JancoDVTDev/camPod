//
//  SavedImages.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/21.
//

import Foundation
import CoreData

public class CoreDataRepo {

    public init() {

    }

    func fetchSavedImagesInCoreData(imagePaths: [String],
                                    _ completion: @escaping (_ photoModels: [PhotoModel],
        _ newPhotosPaths: [String], _ error: String?) -> Void) {

        var images: [NSManagedObject] = []
        var allImageNames = [String]()
        var allImages = [UIImage]()
        var albumRealtedPhotoModels = [PhotoModel]()
        var newPhotosPaths = [String]()
        var errorCount = 0
        var error: String?
        let appDelegate = UIApplication.shared.delegate as? SavedImagesType

        let managedContext = appDelegate!.returnContainer().viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")

        do {
            images = try managedContext.fetch(fetchRequest)
        } catch {
            errorCount += 1
        }

        for image in images {
            //swiftlint:disable all
            let imageName = image.value(forKey: "name") as! String
            //swiftlint:enable all
            allImageNames.append(imageName)
            //swiftlint:disable all
            let imageData = image.value(forKey: "image") as! NSData
            //swiftlint:enable all
            let image = UIImage(data: imageData as Data)
            allImages.append(image!)
        }

        for index in 0..<imagePaths.count {
            if allImageNames.contains(imagePaths[index]) {
                let trueIndex = allImageNames.firstIndex(of: imagePaths[index])
                albumRealtedPhotoModels.append(PhotoModel(name: allImageNames[trueIndex!],
                                                          image: allImages[trueIndex!]))
            } else {
                newPhotosPaths.append(imagePaths[index])
            }
        }

        if errorCount > 0 {
            error = "\(errorCount) Images could not load."
        }

        completion(albumRealtedPhotoModels, newPhotosPaths, error)
    }

    func saveImageToCoreData(photoModel: PhotoModel) {
        let appDelegate = UIApplication.shared.delegate as? SavedImagesType
        let managedContext = appDelegate?.returnContainer().viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Image", in: managedContext!)

        let image = NSManagedObject(entity: entity!, insertInto: managedContext)
        image.setValue(photoModel.name, forKey: "name")
        let imageData = photoModel.image.jpegData(compressionQuality: 1)
        image.setValue(imageData, forKey: "image")

        do {
            try managedContext?.save()
        } catch {

        }
    }
}
