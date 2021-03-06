//
//  SingleAlbumObjCViewModel.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/26.
//

#import <Foundation/Foundation.h>
#import "SingleAlbumModelObjc.h"
#import "SingleAlbumModelObjc.h"
@import FirebaseCore;
@import FirebaseDatabase;
@import FirebaseStorage;
@import FirebaseAnalytics;

NS_ASSUME_NONNULL_BEGIN

@interface SingleAlbumObjCViewModel : NSObject

@property (strong, nonatomic) FIRDatabaseReference *databaseRef;
@property (strong, nonatomic) FIRStorageReference *storageRef;
@property (strong, nonatomic) SingleAlbumModelObjc *album;
@property (strong, nonatomic) NSMutableArray *theNewImagePathReferences;
@property (strong, nonatomic) NSMutableArray *theNewImages;
@property (strong, nonnull) NSArray *observedImagePaths;
@property (strong, nonatomic) UIImage *databaseDownloadedImage;

-(void) downloadImagesFromFirebaseStorage: (NSString *) albumID : (NSArray *) imagePathReferences : (void (^) (SingleAlbumModelObjc *album))completion;
-(void) saveTakenPhotoToDatabase: (SingleAlbumModelObjc *) album : (UIImage *) takenPhoto : (void (^) (SingleAlbumModelObjc *album))completion;
-(NSArray *) appendToLocalAlbum: (NSArray *) images : (UIImage *) takenPhoto;
-(void) saveImageToFirebase: (SingleAlbumModelObjc *) album : (UIImage *) takenPhoto : (void (^) (BOOL success))completion;
-(void) observeAlbum: (NSString *) albumID : (void (^) (NSArray *observedImagePaths))completion;

@end

NS_ASSUME_NONNULL_END
