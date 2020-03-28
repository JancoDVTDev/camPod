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

-(void) downloadImagesFromFirebaseStorage: (NSString *) albumID : (NSArray *) imagePathReferences : (void (^) (SingleAlbumModelObjc *album))completion;
-(void) saveTakenPhotoToDatabase: (SingleAlbumModelObjc *) album : (UIImage *) takenPhoto : (void (^) (SingleAlbumModelObjc *album))completion;

@end

NS_ASSUME_NONNULL_END
