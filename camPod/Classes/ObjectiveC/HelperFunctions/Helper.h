//
//  Helper.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Helper : NSObject

@property NSString *uniqueID;

-(NSString*) generateUniqueID;
-(BOOL) validateSignUpFields : (NSString *) firstName
                              : (NSString *) lastName
                              : (NSString *) email
                              : (NSString *) password;
-(BOOL) validateLoginFields : (NSString *) email
                             : (NSString *) password;

@end

NS_ASSUME_NONNULL_END
