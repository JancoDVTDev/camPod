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
    @IBOutlet var progressView: UIProgressView!

    public var albumID: String = ""
    public var userImagePaths = [String]()
    public var albumName: String = "^&%"

    var collectionViewSource = [UIImage]()
    var photoModels = [PhotoModel]()
    var selectedPhotoIndex = 0

    var photoViewModel = PhotosViewModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.title = albumName

        photoViewModel.view = self
        photoViewModel.repo = PhotosDatasource()
        photoViewModel.cacheHelper = CacheHelper()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera,
        target: self, action: #selector(cameraButtonTapped))

        collectionView.isHidden = true
        collectionView.delegate = self
        collectionView.dataSource = self

        photoViewModel.loadPhotos(albumID: albumID, imagePaths: userImagePaths)

        activityLoader.startAnimating()
        activityLoader.isHidden = false

        photoViewModel.loadPhotos(albumID: albumID, imagePaths: userImagePaths)
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

        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        cell.photoImageView.addGestureRecognizer(imageTapGesture)
        cell.photoImageView.isUserInteractionEnabled = true
        cell.photoImageView.tag = indexPath.item
        cell.photoImageView.image = photoModels[indexPath.item].image//collectionViewSource[indexPath.item] //

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
}

extension PhotosViewController: PhotoViewProtocol {
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