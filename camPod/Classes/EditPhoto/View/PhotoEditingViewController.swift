//
//  PhotoEditingViewController.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/21.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
//swiftlint:disable all
@objcMembers public class PhotoEditingViewController: UIViewController {
//swiftlint:enable all
    @IBOutlet var croppingViewUIView: UIView!
    @IBOutlet var inEditPhotoImageView: UIImageView!
    @IBOutlet var currentFilterLabel: UILabel!
    @IBOutlet var firstFilterButton: UIButton!
    @IBOutlet var secondFilterButton: UIButton!
    @IBOutlet var thirdFilterButton: UIButton!
    @IBOutlet var fourthFIlterButton: UIButton!
    @IBOutlet var fifthFilterButton: UIButton!
    @IBOutlet var applyAmountSlider: UISlider!
    @IBOutlet var sliderValueLabel: UILabel!
    @IBOutlet var adjustButton: UIBarButtonItem!
    @IBOutlet var filterButton: UIBarButtonItem!
    @IBOutlet var cropButton: UIBarButtonItem!

    @objc public var inEditPhoto = UIImage(named: "image-2")!
    @objc public var originalImage = UIImage(named: "image-2")!

    var kResizeThumbSize = 45.0
    var isResizingLR: Bool!
    var isResizingUL: Bool!
    var isResizingUR: Bool!
    var isResizingLL: Bool!
    var touchStart: CGPoint!

    var viewModel = PhotoEditorViewModel()

    var editedPhoto = CIImage()
    var sliderValue: Float?
    var currentFilterIndex: Int?
    var uiButtonCollection = [UIButton]()
    var modeSelected: EditingMode!

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.view = self
        inEditPhotoImageView.image = inEditPhoto

        uiButtonCollection = [firstFilterButton,
                              secondFilterButton,
                              thirdFilterButton,
                              fourthFIlterButton,
                              fifthFilterButton]

        setupAdjustButtons()
        setupToolBarItems()
    }

    @IBAction func firstFilterButtonTapped(_ sender: Any) {
        switch modeSelected {
        case .manual:
            currentFilterLabel.text = "VIBRANCE"
        case .predefined:
            currentFilterLabel.text = "CAMSHARE"
            inEditPhotoImageView.image = fifthFilterButton.backgroundImage(for: .normal)
            //viewModel.applyPredefinedFilter(image: inEditPhoto, selectedFilter: 0)
        case .crop:
            currentFilterLabel.text = "APPLY"
            viewModel.cropImageWithCGRect(image: inEditPhotoImageView.image!,
                                          cropView: croppingViewUIView.self,
                                          imageView: inEditPhotoImageView!)
        case .none:
            currentFilterLabel.text = "Mode not avaialable"
        }
        currentFilterIndex = 0
        filterChanged()
    }

    @IBAction func secondFilterButtonTapped(_ sender: Any) {
        switch modeSelected {
        case .manual:
            currentFilterLabel.text = "EXPOSURE"
        case .predefined:
            currentFilterLabel.text = "COLD"
            inEditPhotoImageView.image = secondFilterButton.backgroundImage(for: .normal)
            //viewModel.applyPredefinedFilter(image: inEditPhoto, selectedFilter: 1)
        case .crop:
            currentFilterLabel.text = "RESET"
            inEditPhotoImageView.image = originalImage
        case .none:
            currentFilterLabel.text = "Mode not avaialable"
        }
        currentFilterIndex = 1
        filterChanged()
    }

    @IBAction func thirdFilterButtonTapped(_ sender: Any) {
        switch modeSelected {
        case .manual:
            currentFilterLabel.text = "GAMMA"
        case .predefined:
            currentFilterLabel.text = "VIVID COLD"
            inEditPhotoImageView.image = thirdFilterButton.backgroundImage(for: .normal)
            //viewModel.applyPredefinedFilter(image: inEditPhoto, selectedFilter: 2)
        case .crop:
            currentFilterLabel.text = "SQUARE"
            viewModel.presetCropView(image: inEditPhotoImageView.image!, imageView: inEditPhotoImageView, preset: .square)
        case .none:
            currentFilterLabel.text = "Mode not avaialable"
        }
        currentFilterIndex = 2
        filterChanged()
    }

    @IBAction func fourthFilterButtonTapped(_ sender: Any) {
        switch modeSelected {
        case .manual:
            currentFilterLabel.text = "VIGNETTE"
        case .predefined:
            currentFilterLabel.text = "WARM"
            inEditPhotoImageView.image = fourthFIlterButton.backgroundImage(for: .normal)
            //viewModel.applyPredefinedFilter(image: inEditPhoto, selectedFilter: 3)
        case .crop:
            currentFilterLabel.text = "LANDSCAPE"
        case .none:
            currentFilterLabel.text = "Mode not avaialable"
        }
        currentFilterIndex = 3
        filterChanged()
    }

    @IBAction func fifthFilterButtonTapped(_ sender: Any) {
        switch modeSelected {
        case .manual:
            currentFilterLabel.text = "TINT"
        case .predefined:
            currentFilterLabel.text = "VIVID WARM"
            inEditPhotoImageView.image = fifthFilterButton.backgroundImage(for: .normal)
            //viewModel.applyPredefinedFilter(image: inEditPhoto, selectedFilter: 4)
        case .crop:
            currentFilterLabel.text = "PORTRAIT"
        case .none:
            currentFilterLabel.text = "Mode not avaialable"
        }
        currentFilterIndex = 4
        filterChanged()
    }
    //swiftlint:disable all
    @IBAction func sliderValueChanged(_ sender: Any) {
        var value = applyAmountSlider.value - 0.5
        value = value * 2
        sliderValue = value
        sliderValueLabel.text = String((value*100).rounded(.up))

        var ciImageCandidate = CIImage()
        if let imageData = inEditPhoto.jpegData(compressionQuality: 1) {
            ciImageCandidate = CIImage(data: imageData)!
        }

        switch currentFilterIndex {
        case 0:
            if #available(iOS 13.0, *) {
                let filter = CIFilter.vibrance()
                filter.amount = value
                filter.inputImage = ciImageCandidate
                inEditPhotoImageView.image = UIImage(ciImage: filter.outputImage!)
            }
        case 1:
            if #available(iOS 13.0, *) {
                let filter = CIFilter.exposureAdjust()
                filter.ev = value
                filter.inputImage = ciImageCandidate
                inEditPhotoImageView.image = UIImage(ciImage: filter.outputImage!)
            }
        case 2:
            if #available(iOS 13.0, *) {
                let filter = CIFilter.gammaAdjust()
                filter.power = value
                filter.inputImage = ciImageCandidate
                inEditPhotoImageView.image = UIImage(ciImage: filter.outputImage!)
            }
        case 3:
            if #available(iOS 13.0, *) {
                let filter = CIFilter.vignette()
                filter.radius = 10
                filter.intensity = value
                filter.inputImage = ciImageCandidate
                inEditPhotoImageView.image = UIImage(ciImage: filter.outputImage!)
            }
        case 4:
            if #available(iOS 13.0, *) {
                let filter = CIFilter.temperatureAndTint()
                filter.inputImage = ciImageCandidate
                value += 0.5
                value *= 2
                filter.neutral = CIVector(x: 6500, y: 0)
                filter.targetNeutral = CIVector(x: CGFloat(value*10000), y: 0)
                inEditPhotoImageView.image = UIImage(ciImage: filter.outputImage!)
            }
        default:
            currentFilterLabel.text = "No Adjustment Selected"
        }
    //swiftlint:enable all
    }

    @available(iOS 13.0, *)
    @IBAction func manualEditingTapped(_ sender: Any) {
        modeChanged(mode: EditingMode.manual)
        modeSelected = EditingMode.manual
    }

    @available(iOS 13.0, *)
    @IBAction func predefinedEditingTapped(_ sender: Any) {
        modeChanged(mode: EditingMode.predefined)
        modeSelected = EditingMode.predefined
    }

    @available(iOS 13.0, *)
    @IBAction func cropEditingTapped(_ sender: Any) {
        modeChanged(mode: EditingMode.crop)
        modeSelected = EditingMode.crop
    }

    @IBAction func doneButtonTapped(_ sender: Any) {

        let alert = UIAlertController(title: "Export Image",
                                      message: "Save image to photos ?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (_) in
            guard let image = self.inEditPhotoImageView.image else {return}
            guard let imageData = image.jpegData(compressionQuality: 1) else {return}
            guard let newImage = UIImage(data: imageData) else {return}
            UIImageWriteToSavedPhotosAlbum(newImage, self,
                                           #selector(self.image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let alert = UIAlertController(title: "Save Error",
                                          message: error.localizedDescription,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Success!",
                                          message: "Your images is saved to photos.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    func filterChanged() {
        if modeSelected == EditingMode.manual || modeSelected == EditingMode.predefined {
            for index in 0..<uiButtonCollection.count {
                if index == currentFilterIndex {
                    let button = uiButtonCollection[index]
                    button.layer.borderColor = UIColor.green.cgColor
                    button.layer.borderWidth = 2
                    button.tintColor = UIColor.green
                } else {
                    let button = uiButtonCollection[index]
                    button.layer.borderColor = UIColor.darkGray.cgColor
                    button.layer.borderWidth = 2
                    button.tintColor = UIColor.white
                }
            }
        }
    }

    @available(iOS 13.0, *)
    func setupCropView() {
        croppingViewUIView.self.frame.size.width = 80
        croppingViewUIView.self.frame.size.height = 80
        croppingViewUIView.self.layer.borderColor = UIColor.white.cgColor
        croppingViewUIView.layer.borderWidth = 2
        croppingViewUIView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        croppingViewUIView.isHidden = false
        croppingViewUIView.alpha = 1

        for index in 0..<uiButtonCollection.count {
            let button = uiButtonCollection[index]
            button.layer.cornerRadius = 3
            button.setBackgroundImage(.none, for: .normal)
            button.tintColor = UIColor.black
            if index == 0 {
                button.setImage(.none, for: .normal)
                button.setImage(UIImage(systemName: "crop"), for: .normal)
                button.tintColor = UIColor.systemGreen
            } else if index == 1 {
                button.setImage(.none, for: .normal)
                button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
                button.tintColor = UIColor.systemPink
            } else if index  == 2 {
                button.setImage(UIImage(systemName: "square"), for: .normal)
            } else if index == 3 {
                button.setImage(.none, for: .normal)
                button.setImage(UIImage(systemName: "rectangle"), for: .normal)
            } else {
                button.setImage(.none, for: .normal)
                button.setImage(UIImage(systemName: "person.crop.rectangle"), for: .normal)
            }
        }

        applyAmountSlider.alpha = 0
        sliderValueLabel.alpha = 0
    }

    func setupToolBarItems() {
        adjustButton.title = ""
        adjustButton.setBackgroundImage(UIImage(named: "Adjust Icon")?.withRenderingMode(.alwaysOriginal),
                                        for: .normal, barMetrics: .default)
        filterButton.title = ""
        filterButton.setBackgroundImage(UIImage(named: "Filters Icon")?.withRenderingMode(.alwaysOriginal),
                                        for: .normal, barMetrics: .default)
        cropButton.title = ""
        cropButton.setBackgroundImage(UIImage(named: "Crop Icon 2")?.withRenderingMode(.alwaysOriginal),
                                        for: .normal, barMetrics: .default)
    }

    func setupAdjustButtons() {
        sliderValueLabel.text = String((applyAmountSlider.value).rounded(.up))
        modeSelected = .manual
        roundAndSetBackgroundColorButtons()
        placeIconsOnAdjustButtons()
    }

    func placeIconsOnAdjustButtons() {
        firstFilterButton.setImage(UIImage(named: "Vibrance Icon"), for: .normal)
        secondFilterButton.setImage(UIImage(named: "Exposure Icon"), for: .normal)
        thirdFilterButton.setImage(UIImage(named: "Gamma Icon"), for: .normal)
        fourthFIlterButton.setImage(UIImage(named: "Vignette Icon"), for: .normal)
        fifthFilterButton.setImage(UIImage(named: "Tint Icon"), for: .normal)
    }

    func roundAndSetBackgroundColorButtons() {
        for button in uiButtonCollection {
            button.layer.cornerRadius = button.frame.size.width/2
            button.layer.borderColor = UIColor.black.cgColor
            button.layer.borderWidth = 2
            button.layer.backgroundColor = UIColor.clear.cgColor
            button.setBackgroundImage(.none, for: .normal)
        }
    }

    @available(iOS 13.0, *)
    func modeChanged(mode: EditingMode) {
        switch mode {
        case EditingMode.manual:
            currentFilterLabel.text = "ADJUST"
            applyAmountSlider.alpha = 1
            sliderValueLabel.alpha = 1
            setupAdjustButtons()
        case EditingMode.predefined:
            currentFilterLabel.text = "CHOOSE A FILTER"
            let thumbnails = [viewModel.createCamShareCustionFilter(image: inEditPhoto),
                              viewModel.createColdFilter(image: inEditPhoto),
                              viewModel.createColdVividFilter(image: inEditPhoto),
                              viewModel.createWarmFilter(image: inEditPhoto),
                              viewModel.createWarmVididFilter(image: inEditPhoto)]
            for index in 0..<uiButtonCollection.count {
                let button = uiButtonCollection[index]
                button.setImage(.none, for: .normal)
                button.setBackgroundImage(UIImage(ciImage: thumbnails[index]), for: .normal)
                button.layer.cornerRadius = button.frame.size.width/4
                button.layer.masksToBounds = true
            }
            applyAmountSlider.alpha = 0
            sliderValueLabel.alpha = 0
        case EditingMode.crop:
            currentFilterLabel.text = "CROP"
            setupCropView()
        }
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesSet = touches as NSSet
        let touch = touchesSet.anyObject() as! UITouch

        touchStart = touch.location(in: croppingViewUIView.self)

        isResizingLR = croppingViewUIView.self.bounds.size.width - touchStart.x <
            CGFloat(kResizeThumbSize) && croppingViewUIView.self.bounds.size.height -
            touchStart.y < CGFloat(kResizeThumbSize)
        isResizingUL = touchStart.x < CGFloat(kResizeThumbSize) && touchStart.y <
            CGFloat(kResizeThumbSize)
        isResizingUR = (croppingViewUIView.self.bounds.size.width-touchStart.x <
            CGFloat(kResizeThumbSize) && touchStart.y < CGFloat(kResizeThumbSize));
        isResizingLL = (touchStart.x < CGFloat(kResizeThumbSize) &&
            croppingViewUIView.self.bounds.size.height - touchStart.y <
            CGFloat(kResizeThumbSize));
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchesSet = touches as NSSet
        let touch = touchesSet.anyObject() as! UITouch

        let touchPoint = touch.location(in: croppingViewUIView.self)
        let previous = touch.previousLocation(in: croppingViewUIView.self)

        let deltaWidth = touchPoint.x - previous.x
        let deltaHeight = touchPoint.y - previous.y

        let x = croppingViewUIView.self.frame.origin.x
        let y = croppingViewUIView.self.frame.origin.y
        let width = croppingViewUIView.self.frame.size.width
        let height = croppingViewUIView.self.frame.size.height

        if isResizingLR {
            croppingViewUIView.self.frame = CGRect(x: x, y: y, width: touchPoint.x + deltaWidth,
                                                   height: touchPoint.y + deltaHeight)
        } else if isResizingUL {
            croppingViewUIView.self.frame = CGRect(x: x+deltaWidth, y: y+deltaHeight,
                                                   width: width-deltaWidth, height: height-deltaHeight)
        } else if isResizingUR {
            croppingViewUIView.self.frame = CGRect(x: x, y: y+deltaHeight,
                                                   width: width+deltaWidth, height: height-deltaHeight)
        } else if isResizingLL {
            croppingViewUIView.self.frame = CGRect(x: x+deltaWidth, y: y,
                                                   width: width-deltaWidth, height: height+deltaHeight)
        } else {
            croppingViewUIView.self.center = CGPoint(x: croppingViewUIView.self.center.x +
                touchPoint.x - touchStart.x, y: croppingViewUIView.self.center.y +
                    touchPoint.y - touchStart.y)
        }
    }
}
extension PhotoEditingViewController: PhotoEditorViewType {
    func displayPresetCropView(rect: CGRect) {
        croppingViewUIView.frame = rect
    }
    
    func updateImageView(image: CIImage) {
        inEditPhotoImageView.image = UIImage(ciImage: image)
    }
}

enum EditingMode {
    case manual
    case predefined
    case crop
}
