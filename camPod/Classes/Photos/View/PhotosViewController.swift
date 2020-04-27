//
//  PhotosViewController.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import UIKit

public class PhotosViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityLoader: UIActivityIndicatorView!
    @IBOutlet var activityLabel: UILabel!
    @IBOutlet var progressView: UIProgressView!

    public var albumID: String = ""
    public var userImagePaths = [String]()
    public var albumName: String = "^&%"

    var collectionViewSource = [UIImage]()
    var photoModels = [PhotoModel]()
    var selectedPhotoIndex = 0
    var downloadTrigger = false

    var photoViewModel = PhotosViewModel()
    
    var indexPathDictionary: [IndexPath: Bool] = [:]

    lazy var selectBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Select", style: .plain, target: self,
                                            action: #selector(self.tapSelectBarButton(_:)))
        return barButtonItem
    }()

    lazy var deleteBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self,
                                            action: #selector(self.tapDeleteBarButton(_:)))
        return barButtonItem
    }()

    lazy var cameraBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self,
                                            action: #selector(self.cameraButtonTapped))
        return barButtonItem
    }()

    var mode: Mode = .view {
        didSet {
            switch mode {
            case .view:
                for (key, value) in indexPathDictionary where value{
                    collectionView.deselectItem(at: key, animated: true)
                }

                indexPathDictionary.removeAll()

                selectBarButtonItem.title = "Select"
                collectionView.allowsMultipleSelection = false
                navigationItem.rightBarButtonItems = [selectBarButtonItem, cameraBarButtonItem]
                break
            case .select:
                selectBarButtonItem.title = "Cancel"
                collectionView.allowsMultipleSelection = true
                navigationItem.rightBarButtonItems = [selectBarButtonItem, deleteBarButtonItem]
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = albumName
        setupBarButtonItems()

        photoViewModel.view = self
        photoViewModel.repo = PhotosDatasource()
        photoViewModel.cacheHelper = CacheHelper()

        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self

        activityLoader.startAnimating()
        activityLoader.isHidden = false

        photoViewModel.loadPhotos(albumID: albumID, imagePaths: userImagePaths)
    }

    func setupBarButtonItems() {
        navigationItem.rightBarButtonItems = [selectBarButtonItem, cameraBarButtonItem]
    }

    @objc func tapSelectBarButton(_ sender: AnyObject) {
        mode = mode == .view ? .select: .view
    }

    @objc func tapDeleteBarButton(_ sender: AnyObject) {

        let alertSheet = UIAlertController(title: "Delete Photos ?",
                                           message: "Deleting photos will effect the other members photo's too",
                                           preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (_) in
            var deleteIndexPaths = [IndexPath]()
            var deleteImagePaths = [String]()
            for (key, value) in self.indexPathDictionary where value{
                deleteImagePaths.append(self.photoModels[key.item].name)
                deleteIndexPaths.append(key)
            }

            for imagePath in deleteImagePaths {
                self.userImagePaths.removeAll { $0 == imagePath }
            }

            for index in deleteIndexPaths.sorted(by: { $0.item > $1.item }) {
                self.photoModels.remove(at: index.item)
            }

            self.collectionView.deleteItems(at: deleteIndexPaths)
            self.photoViewModel.deleteImages(albumID: self.albumID, imagePaths: self.userImagePaths,
                                             deleteImagePaths: deleteImagePaths)
            self.indexPathDictionary.removeAll()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alertSheet.addAction(deleteAction)
        alertSheet.addAction(cancelAction)
        present(alertSheet, animated: true, completion: nil)
    }

    @objc func cameraButtonTapped() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let takenPhoto = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Photo was taken")
            photoViewModel.savePhoto(albumID: albumID, imagePaths: userImagePaths,
                                     takenPhoto: takenPhoto, photoModels: photoModels)
        }
        picker.dismiss(animated: false, completion: nil)
    }

    @IBAction func shareButtonTapped(_ sender: Any) {
        let shareActionSheet = UIAlertController(title: "Share Album", message: "Choose an option",
                                                 preferredStyle: .actionSheet)

        let shareAction = UIAlertAction(title: "Generate QR Code", style: .default) { (_) in
            print("Navigate To QR Code")
            self.performSegue(withIdentifier: "goToQRCode", sender: self)
        }

        let copyAlbumID = UIAlertAction(title: "Copy Album ID", style: .default) { (_) in
            UIPasteboard.general.string = self.albumID
            let alert = UIAlertController(title: "Copied", message: self.albumID, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        shareActionSheet.addAction(shareAction)
        shareActionSheet.addAction(copyAlbumID)
        shareActionSheet.addAction(cancel)
        present(shareActionSheet, animated: true, completion: nil)
    }

    @IBAction func tipsAndTricksButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: "loadTipsAndTricks", sender: self)
    }
}

extension PhotosViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 4
        let width = collectionView.frame.size.width
        let xInsets: CGFloat = 2
        let cellSpacing: CGFloat = 5
        return CGSize(width: (width/numberOfColumns) - (cellSpacing), height: (width/numberOfColumns) -
            (xInsets + cellSpacing))
    }
}

extension PhotosViewController: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoModels.count//collectionViewSource.count //Now use photoModels.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotoCollectionCellCollectionViewCell

        cell.photoImageView.image = photoModels[indexPath.item].image

        return cell
    }

    @objc func imageTapped(_ sender: AnyObject) {
        selectedPhotoIndex = sender.view.tag
        self.performSegue(withIdentifier: "displayImage", sender: self)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "displayImage" {
            let singleImageViewController = segue.destination as! SelectedImageObjCViewController
            singleImageViewController.selectedImage = photoModels[selectedPhotoIndex].image
        }

        if segue.identifier == "goToQRCode" {
            let qrCodeViewController = segue.destination as! QRCodeGeneratorObjCViewController
            qrCodeViewController.albumID = self.albumID
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               didSelectItemAt indexPath: IndexPath) {
        switch mode {
        case .view:
            collectionView.deselectItem(at: indexPath, animated: true)
            selectedPhotoIndex = indexPath.item
            self.performSegue(withIdentifier: "displayImage", sender: self)
        default:
            indexPathDictionary[indexPath] = true
        }
    }

    public func collectionView(_ collectionView: UICollectionView,
                               didDeselectItemAt indexPath: IndexPath) {
        if mode == .select {
            indexPathDictionary[indexPath] = false
        }
    }
}

extension PhotosViewController: PhotoViewProtocol {
    public func startDownloading() {
        self.activityLoader.startAnimating()
        self.activityLoader.isHidden = false
        downloadTrigger = !downloadTrigger
    }

    public func updatePhotoModels(photoModels: [PhotoModel]) {
        self.photoModels = photoModels
    }

    public func updateImagePaths(imagePaths: [String]) {
        userImagePaths = imagePaths
    }

    public func updateCollectionView() {
        collectionView.reloadData()
    }

    public func didFinishLoading() {
        activityLoader.isHidden = true
        activityLoader.stopAnimating()
        collectionView.isHidden = false
        activityLabel.isHidden = true
        photoViewModel.observeTakenPhotos(albumID: albumID, imagePaths: userImagePaths, photoModels: photoModels)
    }

    public func displayError(error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    public func updateCollectionViewSource(images: [UIImage]) {
        collectionViewSource = images
    }
}

enum Mode {
    case view
    case select
}
