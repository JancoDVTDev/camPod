//
//  SingleAlbumModelObjc.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SingleAlbumModelObjc : NSObject

@property NSString *albumID;
@property NSArray *images;

- (instancetype) initWithAlbumID: (NSString *) albumID images: (NSArray *) images;

@end

NS_ASSUME_NONNULL_END
