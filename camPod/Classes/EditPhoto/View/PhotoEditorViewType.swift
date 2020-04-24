//
//  PhotoEditorViewType.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/21.
//

import Foundation

protocol PhotoEditorViewType {
    func updateImageView(image: CIImage)
    func displayPresetCropView(rect: CGRect)
}
