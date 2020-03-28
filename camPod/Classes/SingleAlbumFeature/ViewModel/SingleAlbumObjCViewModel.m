//
//  SingleAlbumObjCViewModel.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/26.
//

#import "SingleAlbumObjCViewModel.h"
@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseCore;

@implementation SingleAlbumObjCViewModel


-(void) downloadImagesFromFirebaseStorage: (NSString *) albumID : (NSArray *) imagePathReferences : (void (^) (SingleAlbumModelObjc *album))completion {
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i = 0; i < imagePathReferences.count;  i++) {
        [self downloadSingleImage:albumID :imagePathReferences[i] :^(UIImage *image) {
            [images addObject:image];
            if (i == imagePathReferences.count - 1) {
                self.album = [[SingleAlbumModelObjc alloc] initWithAlbumID:albumID images:images imagePathReferences:imagePathReferences];
                completion(self.album);
            }
        }];
    }
}

-(void) downloadSingleImage:(NSString *) albumID : (NSString *) imagePath : (void (^) (UIImage *image))completion {
    FIRStorage *storage = [FIRStorage storage];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",albumID,imagePath,imagePath];
    self.storageRef = [storage referenceWithPath:path];
    [self.storageRef dataWithMaxSize:4 * 1024 * 1024 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            UIImage *image = [UIImage imageWithData:data];
            completion(image);
        }
    }];
}

-(void) saveTakenPhotoToDatabase: (SingleAlbumModelObjc *) album : (UIImage *) takenPhoto : (void (^) (SingleAlbumModelObjc *album))completion {
    //Make a unique string ID - uuid
    NSString *newPhotoName = [[NSUUID UUID] UUIDString];
    NSMutableArray *theNewImagePathReferences = [[NSMutableArray alloc] init];
    NSMutableArray *theNewImages = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < album.imagePathReferences.count; i++) {
        [theNewImagePathReferences addObject:album.imagePathReferences[i]];
    }
    
    for (int i = 0; i < album.images.count; i++) {
        [theNewImages addObject:album.images[i]];
    }
    NSData *imageData = UIImageJPEGRepresentation(takenPhoto,0.5);
    FIRStorageMetadata *metaData = [[FIRStorageMetadata alloc] init];
    metaData.contentType = @"image/jpeg";
    
    FIRStorage *storageRef = [FIRStorage storage];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",album.albumID,newPhotoName,newPhotoName];
    FIRStorageReference *newImageStorageRef = [storageRef referenceWithPath:path];
    [newImageStorageRef putData:imageData metadata:metaData completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error");
        } else {
            FIRDatabaseReference *databaseRef = [[FIRDatabase database] reference];
            [theNewImagePathReferences addObject:newPhotoName];
            [theNewImages addObject:takenPhoto];
            [[[[databaseRef child:@"AllAlbumsExisting"] child:album.albumID] child:@"ImagePaths"] setValue:theNewImagePathReferences];
            [self.album updateAlbum:album.albumID images:theNewImages imagePathReferences:theNewImagePathReferences];
            completion(self.album);
            //return a new album
        }
    }];
}

@end
