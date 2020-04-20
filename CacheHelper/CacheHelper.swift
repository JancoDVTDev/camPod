//
//  CacheHelper.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/20.
//

import Foundation

public class CacheHelper {

    public init() { }

    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        guard let data = image.jpegData(compressionQuality: 1) else { return }

        if (FileManager.default.fileExists(atPath: fileURL.path)) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func loadImageFromDisk(fileName: String, _ completion: @escaping (_ notUpToDate: String?,
        _ image: UIImage?) -> Void) {

        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else { return }

        let fileURL = documentsDirectory.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.path) {
            if let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentsUrl.appendingPathComponent(fileName)
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    let image =  UIImage(data: imageData)
                    completion(nil, image)
                } catch {
                    print("Not able to load image")
                    completion(fileName, nil)
                }
            }
        } else {
            completion(fileName, nil)
        }
    }
}
