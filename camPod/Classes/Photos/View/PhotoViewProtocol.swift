//
//  PhotoViewProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation

public protocol PhotoViewProtocol: class {
    func updateCollectionView()
    func didFinishLoading()
    func displayError(error: String)
    func updateCollectionViewSource(images: [UIImage])
    func updateImagePaths(imagePaths: [String])
}
