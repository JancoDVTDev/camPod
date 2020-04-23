//
//  PhotoEditorViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/21.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins

public class PhotoEditorViewModel {

    var view: PhotoEditorViewType?
    var currentFilterIndex = 0

    public init() {

    }

    func changeFilter(index: Int) {
        currentFilterIndex = index
    }
    //swiftlint:disable all
    func applyPredefinedFilter(image: UIImage, selectedFilter: Int) {
    //swiftlint:enable all
        switch selectedFilter {
        case 0:
            print("camShare")
            if #available(iOS 13.0, *) {
                let result = createCamShareCustionFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 1:
            print("Cold")
            if #available(iOS 13.0, *) {
                let result = createColdFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 2:
            print("Vivid Cold")
            if #available(iOS 13.0, *) {
                let result = createColdVividFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 3:
            print("")
            if #available(iOS 13.0, *) {
                let result = createWarmFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 4:
            print("")
            if #available(iOS 13.0, *) {
                let result = createWarmVididFilter(image: image)
                view?.updateImageView(image: result)
            }
        default:
            print("")
        }
    }

    @available(iOS 13.0, *)
    func createCamShareCustionFilter(image: UIImage) -> CIImage{
        var ciImageCandidate = CIImage()
        if let imageData = image.jpegData(compressionQuality: 1) {
            ciImageCandidate = CIImage(data: imageData)!
        }

        let filter = CIFilter.temperatureAndTint()
        filter.neutral = CIVector(x: 6500, y: 0)
        filter.targetNeutral = CIVector(x: 7800, y: 0)
        filter.inputImage = ciImageCandidate
        var result = filter.outputImage
        let secondFilter = CIFilter.vibrance()
        secondFilter.amount = -0.5
        secondFilter.inputImage = result
        result = secondFilter.outputImage
        let thirdFilter = CIFilter.vignette()
        thirdFilter.radius = 1
        thirdFilter.intensity = 0.5
        thirdFilter.inputImage = result
        result = thirdFilter.outputImage
        return result!
    }

    @available(iOS 13.0, *)
    func createColdFilter(image: UIImage) -> CIImage {
        var ciImageCandidate = CIImage()
        if let imageData = image.jpegData(compressionQuality: 1) {
            ciImageCandidate = CIImage(data: imageData)!
        }

        let filter = CIFilter.temperatureAndTint()
        filter.neutral = CIVector(x: 6500, y: 0)
        filter.targetNeutral = CIVector(x: 9000, y: 0)
        filter.inputImage = ciImageCandidate
        let result = filter.outputImage
        return result!
    }

    @available(iOS 13.0, *)
    func createColdVividFilter(image: UIImage) -> CIImage {
        var ciImageCandidate = CIImage()
        if let imageData = image.jpegData(compressionQuality: 1) {
            ciImageCandidate = CIImage(data: imageData)!
        }

        let filter = CIFilter.temperatureAndTint()
        filter.neutral = CIVector(x: 6500, y: 0)
        filter.targetNeutral = CIVector(x: 9000, y: 0)
        filter.inputImage = ciImageCandidate
        var result = filter.outputImage
        let secondFilter = CIFilter.vibrance()
        secondFilter.amount = 1.25
        secondFilter.inputImage = result
        result = secondFilter.outputImage
        return result!
    }

    @available(iOS 13.0, *)
    func createWarmFilter(image: UIImage) -> CIImage {
        var ciImageCandidate = CIImage()
        if let imageData = image.jpegData(compressionQuality: 1) {
            ciImageCandidate = CIImage(data: imageData)!
        }

        let filter = CIFilter.temperatureAndTint()
        filter.neutral = CIVector(x: 6500, y: 0)
        filter.targetNeutral = CIVector(x: 4000, y: 0)
        filter.inputImage = ciImageCandidate
        let result = filter.outputImage
        return result!
    }

    @available(iOS 13.0, *)
    func createWarmVididFilter(image: UIImage) -> CIImage {
        var ciImageCandidate = CIImage()
        if let imageData = image.jpegData(compressionQuality: 1) {
            ciImageCandidate = CIImage(data: imageData)!
        }

        let filter = CIFilter.temperatureAndTint()
        filter.neutral = CIVector(x: 6500, y: 0)
        filter.targetNeutral = CIVector(x: 4000, y: 0)
        filter.inputImage = ciImageCandidate
        var result = filter.outputImage
        let secondFilter = CIFilter.vibrance()
        secondFilter.amount = -0.9
        secondFilter.inputImage = result
        result = secondFilter.outputImage
        return result!
    }
}
