//
//  SingleAlbumModelObjc.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/27.
//

#import "SingleAlbumModelObjc.h"

@implementation SingleAlbumModelObjc
- (instancetype) initWithAlbumID: (NSString *) albumID images: (NSArray *) images {
    self = [super init];
    if (!self) return nil;
    
    _albumID = [albumID copy];
    _images = [images copy];
    
    return self;
}
    
@end
