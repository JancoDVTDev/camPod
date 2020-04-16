//
//  AlbumViewProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/14.
//

import Foundation

public protocol AlbumViewProtocol: class {
    func setAlbumCollectionViewSource(singleAlbums: [SingleAlbum])
    func didFinishLoading()
    func displayError(error: String)
    func updateUserAlbumIDs(albumIDs: [String])
    func updateAlbumCollectionViewSource(singleAlbums: [SingleAlbum])
    func updateAlbumCollectionView()
}
