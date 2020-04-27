//
//  AlbumDataSourceProtocol.swift
//  camPod
//
//  Created by Janco Erasmus on 2020/04/15.
//

import Foundation

public protocol AlbumDataSourceProtocol: class {
    func fetchUserAlbumIDs(_ completion: @escaping (_ albumIDs: [String]?,_ error: String?) -> Void)
    func fetchUserSingleAlbum(albumID: String,
                               completion: @escaping(_ singleAlbum: SingleAlbum?,_ error: String?) -> Void)
    func createNewAlbum(albumName: String, albumID: String,
                        _ completion: @escaping(_ singleAlbum: SingleAlbum) -> Void)
    func addAlbumToUserAlbums(albumIDs: [String],_ completion: @escaping (_ completed: Bool) -> Void)
    func deleteAlbumsFromUserAlbums(updatedUserAlbums: [String])
}
