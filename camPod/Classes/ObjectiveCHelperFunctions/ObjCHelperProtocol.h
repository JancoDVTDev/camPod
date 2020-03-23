//
//  ObjCHelperProtocol.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/23.
//

#import <Foundation/Foundation.h>

@protocol ObjCHelperProtocol <NSObject>

@required
-(NSString*) generateUniqueID;
-(BOOL) validateSignUpFields : (NSString *) firstName
                              : (NSString *) lastName
                              : (NSString *) email
                              : (NSString *) password;
-(BOOL) validateLoginFields : (NSString *) email
                             : (NSString *) password;
-(NSString *) validPassword:(NSString *)password isValid:(BOOL *)valid;
@end
