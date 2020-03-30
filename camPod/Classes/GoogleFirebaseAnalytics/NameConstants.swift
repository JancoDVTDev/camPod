//
//  NameConstants.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/03/30.
//

import Foundation

public struct NameConstants {
    // MARK: Login
    // Buttons
    public static let login = "login_tapped"

    // MARK: PhotoAlbumViewContoleer
    // MARK: Add Album
    // Buttons
    public static let addAlbum = "add_album_tapped"
    public static let createNewAlbum = "create_new_album_tapped"
    public static let scanQRCode = "scan_qr_code_tapped"
    public static let existingAlbum = "existing_album_tapped"
    public static let cancelAdd = "cancel_add_button_tapped"
    public static let cancelCreateNew = "cancel_create_new_tapped"
    public static let cancelExisting = "cancel_existing_tapped"
    public static let saveCreateNew = "save_create_new_tapped"
    public static let saveExisting = "save_existing_tapped"

    //Camera
    public static let cameraOpened = "camera_opened"

    //Functions
    public static let albumCreated = "new_album_created"
    public static let albumAddedQR = "new_album_added_with_QR"
    public static let albumAddedID = "new_album_added_with_ID"
    
    // MARK: SingleAlbumObjCViewController
    // MARK: Share Album
    // Buttons
    public static let shareAlbum = "share_album_tapped"
    public static let generateQR = "generate_qr_code_tapped"
    public static let copyAlbumID = "copy_album_id_tapped"
    public static let cancelShare = "cancel_share_tapped"
    public static let deleteAlbum = "delete_album_tapped"
    public static let camera = "camera_tapped"
}
