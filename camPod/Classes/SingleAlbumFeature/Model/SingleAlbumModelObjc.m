//
//  SingleAlbumModelObjc.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/27.
//

#import "SingleAlbumModelObjc.h"

@implementation SingleAlbumModelObjc
- (instancetype) initWithAlbumID: (NSString *) albumID images: (NSArray *) images imagePathReferences: (NSArray *) imagePathReference{
    self = [super init];
    if (!self) return nil;
    
    _albumID = [albumID copy];
    _images = [images copy];
    _imagePathReferences = [imagePathReference copy];

    return self;
}

- (void) updateAlbum: (NSString *) albumID images: (NSArray *) images imagePathReferences: (NSArray *) imagePathReference {
    self.albumID = albumID;
    self.images = images;
    self.imagePathReferences = imagePathReference;
}
    
@end
