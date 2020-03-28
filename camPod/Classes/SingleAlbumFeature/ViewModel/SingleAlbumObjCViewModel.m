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
                self.album = [[SingleAlbumModelObjc alloc] initWithAlbumID:albumID images:images];
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

-(void) updateAlbumImagePaths: (NSString *)imagePathReference {
    
}

@end
