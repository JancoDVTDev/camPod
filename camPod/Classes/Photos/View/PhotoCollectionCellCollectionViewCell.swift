//
//  PhotoCollectionCellCollectionViewCell.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/16.
//

import UIKit

class PhotoCollectionCellCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var selectedIndicator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override var isHighlighted: Bool {
        didSet {
            selectedIndicator.isHidden = !isHighlighted
        }
    }

    override var isSelected: Bool {
        didSet {
            selectedIndicator.isHidden = !isSelected
        }
    }
}
