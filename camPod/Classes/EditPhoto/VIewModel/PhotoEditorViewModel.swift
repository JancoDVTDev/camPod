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
            if #available(iOS 13.0, *) {
                let result = createCamShareCustionFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 1:
            if #available(iOS 13.0, *) {
                let result = createColdFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 2:
            if #available(iOS 13.0, *) {
                let result = createColdVividFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 3:
            if #available(iOS 13.0, *) {
                let result = createWarmFilter(image: image)
                view?.updateImageView(image: result)
            }
        case 4:
            if #available(iOS 13.0, *) {
                let result = createWarmVididFilter(image: image)
                view?.updateImageView(image: result)
            }
        default:
            break
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

    func cropImageWithCGRect(image: UIImage, cropView: UIView, imageView: UIImageView) {
        guard let imageData = image.jpegData(compressionQuality: 1) else {return}
        guard let newImage = UIImage(data: imageData) else {return}
        let cgCropImage = newImage.cgImage
        let originalCGCropImageWidth = cgCropImage!.width
        let originalCGCropImageHeight = cgCropImage!.height
        let imageViewWidth = imageView.frame.size.width
        let imageViewHeight = imageView.frame.size.height
        var scaledWidth: CGFloat!
        var scaledHeight: CGFloat!
        var scaledOriginX: CGFloat = 0
        var scaledOriginY: CGFloat = 0

        if originalCGCropImageWidth > originalCGCropImageHeight {
            let scaleFactor = originalCGCropImageWidth
            let scaleTotal = CGFloat(originalCGCropImageHeight) * CGFloat(imageViewWidth)
            scaledHeight = scaleTotal/CGFloat(scaleFactor)
            scaledWidth = CGFloat(imageViewWidth)
        } else {
            let scaleFactor = originalCGCropImageHeight
            let scaleTotal = CGFloat(originalCGCropImageWidth) * CGFloat(imageViewHeight)
            scaledWidth = scaleTotal/CGFloat(scaleFactor)
            scaledHeight = CGFloat(imageViewHeight)
        }

        let scaleFactorX = CGFloat(cgCropImage!.width)/scaledWidth
        let scaleFactorY = CGFloat(cgCropImage!.height)/scaledHeight

        if originalCGCropImageWidth > originalCGCropImageHeight {
            scaledOriginY = (CGFloat(imageViewHeight - scaledHeight!)) * scaleFactorY
            scaledOriginX = cropView.frame.origin.x * scaleFactorX
        } else {
            scaledOriginX = (CGFloat(imageViewWidth - scaledWidth!)) * scaleFactorX
            scaledOriginY = (cropView.frame.origin.y) * scaleFactorY
        }

        let realCropWidth = cropView.frame.size.width * scaleFactorX
        let realCropHeight = cropView.frame.size.height * scaleFactorY
        let rect = CGRect(x: scaledOriginX, y: scaledOriginY,
                          width: realCropWidth, height: realCropHeight)
        let croppedImage = cgCropImage?.cropping(to: rect)
        view?.updateImageView(image: CIImage(cgImage: croppedImage!))
    }

    func presetCropView(image: UIImage, imageView: UIImageView, preset: CropPresets) {
        guard let imageData = image.jpegData(compressionQuality: 1) else {return}
        guard let newImage = UIImage(data: imageData) else {return}
        let cgCropImage = newImage.cgImage
        let originalCGCropImageWidth = cgCropImage!.width
        let originalCGCropImageHeight = cgCropImage!.height
        let isLandscape = originalCGCropImageWidth > originalCGCropImageHeight ? true : false
        var scaledWidth: CGFloat!
        var scaledHeight: CGFloat!

        if isLandscape {
            let scaleFactor = originalCGCropImageWidth
            let scaleTotal = CGFloat(originalCGCropImageHeight) * CGFloat(imageView.frame.width)
            scaledHeight = scaleTotal/CGFloat(scaleFactor)
            scaledWidth = CGFloat(imageView.frame.width)
        } else {
            let scaleFactor = originalCGCropImageHeight
            let scaleTotal = CGFloat(originalCGCropImageWidth) * CGFloat(imageView.frame.height)
            scaledWidth = scaleTotal/CGFloat(scaleFactor)
            scaledHeight = CGFloat(imageView.frame.height)
        }

        let widthMiddle = scaledWidth/2
        let heightMiddle = scaledHeight/2
        var rectOriginX: CGFloat!
        var rectOriginY: CGFloat!

        switch preset {
        case .square:
            let rectWidth = isLandscape ? scaledHeight : scaledWidth
            let rectHeight = isLandscape ? scaledHeight : scaledWidth

            if isLandscape {
                rectOriginX = CGFloat(widthMiddle) - CGFloat(Int(rectWidth!/2))
                rectOriginY = CGFloat(imageView.frame.size.height) - scaledHeight
            } else {
                rectOriginX = imageView.frame.origin.x + (imageView.frame.size.width - scaledWidth)/2
                rectOriginY = heightMiddle - scaledHeight/5
            }

            let rect = CGRect(x: rectOriginX, y: rectOriginY, width: rectWidth!, height: rectHeight!)

            view?.displayPresetCropView(rect: rect)
        case .landscape:
            var rectWidth = isLandscape ? scaledHeight : scaledWidth
            var rectHeight = isLandscape ? scaledHeight : scaledWidth

            rectWidth! /= 3
            rectWidth! *= 2
            rectHeight! /= 3
            if isLandscape {
                rectOriginX = CGFloat(widthMiddle) - CGFloat(Int(rectWidth!/2))
                rectOriginY = CGFloat(imageView.frame.size.height) - scaledHeight
            } else {
                rectOriginX = imageView.frame.origin.x + (imageView.frame.size.width - scaledWidth)/2
                rectOriginY = heightMiddle - scaledHeight/5
            }

            let rect = CGRect(x: rectOriginX, y: rectOriginY, width: rectWidth!, height: rectHeight!)

            view?.displayPresetCropView(rect: rect)
        case .portrait:
            break
        }
    }
}
enum CropPresets {
    case square
    case landscape
    case portrait
}
