//
//  ObjcHelper.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/23.
//

#import <Foundation/Foundation.h>
#import "ObjCHelperProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ObjcHelper : NSObject <ObjCHelperProtocol>

@property NSString *uniqueID;
@property NSString *chars;
@property NSCharacterSet *special;
@property NSCharacterSet *capital;
@property NSCharacterSet *number;
@property NSString *error;

@end

NS_ASSUME_NONNULL_END
