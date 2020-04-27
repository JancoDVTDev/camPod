//
//  AlbumViewModel.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation

public class AlbumViewModel {
    public weak var view: AlbumViewProtocol?
    public var repo: AlbumDataSourceProtocol?

    public init() { }

    public func loadAlbums() {
        self.repo?.fetchUserAlbumIDs({ (albums, error) in
            if let error = error {
                self.view?.displayError(error: error)
            } else {
                if let albums = albums {
                    if albums.contains("") {
                        self.view?.didFinishLoading()
                    } else {
                        self.view?.updateUserAlbumIDs(albumIDs: albums)
                        var tempSingleAlbums = [SingleAlbum]()
                        var count = 0
                        for albumID in albums {
                            self.repo?.fetchUserSingleAlbum(albumID: albumID, completion: { (singleAlbum, error) in
                                if let error = error {
                                    self.view?.displayError(error: error)
                                } else {
                                    if let singleAlbum = singleAlbum {
                                        tempSingleAlbums.append(singleAlbum)
                                        count += 1
                                        if count == albums.count {
                                            self.view?.setAlbumCollectionViewSource(singleAlbums: tempSingleAlbums)
                                            self.view?.didFinishLoading()
                                            self.view?.updateAlbumCollectionView()
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
            }
        })
    }

    public func createNewAlbum(albumName: String, albumIDs: [String], currentAlbums: [SingleAlbum]) {
        let helpingHand = ObjcHelper()
        let newAlbumID = helpingHand.generateUniqueID()
        repo?.createNewAlbum(albumName: albumName, albumID: newAlbumID!, { (newAlbum) in
            var updatedAlbumIDs = albumIDs
            updatedAlbumIDs.append(newAlbumID!)

            self.repo?.addAlbumToUserAlbums(albumIDs: updatedAlbumIDs, { (_) in
                var updatedCollectionViewSource = currentAlbums
                updatedCollectionViewSource.append(newAlbum)

                self.view?.updateUserAlbumIDs(albumIDs: updatedAlbumIDs)
                self.view?.updateAlbumCollectionViewSource(singleAlbums: updatedCollectionViewSource)
                self.view?.didFinishLoading()
            })
        })
    }

    public func addExisting(albumID: String, albumIDs: [String], currentAlbums: [SingleAlbum]) {
        var updatedAlbumIDs = albumIDs
        updatedAlbumIDs.append(albumID)

        var updatedCollectionViewSource = currentAlbums

        repo?.fetchUserSingleAlbum(albumID: albumID, completion: { (singleAlbum, error) in
            if let error = error {
                self.view?.displayError(error: error)
            } else {
                self.repo?.addAlbumToUserAlbums(albumIDs: updatedAlbumIDs, { (_) in
                    updatedCollectionViewSource.append(singleAlbum!)
                    self.view?.updateUserAlbumIDs(albumIDs: updatedAlbumIDs)
                    self.view?.updateAlbumCollectionViewSource(singleAlbums: updatedCollectionViewSource)
                    self.view?.updateAlbumCollectionView()
                })
                
            }
        })
    }

    public func deleteAlbums(updatedAlbumIDs: [String]) {
        repo?.deleteAlbumsFromUserAlbums(updatedUserAlbums: updatedAlbumIDs)
    }
}
