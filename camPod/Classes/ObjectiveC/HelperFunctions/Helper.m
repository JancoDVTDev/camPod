//
//  Helper.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/21.
//

#import "Helper.h"

@implementation Helper

-(NSString*) generateUniqueID {

    NSString *chars = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890abcdefghijklmnopqrstuvwxyz";
    NSString *uniqueID;

    for (int i = 0; i < 25; i++) {
        int randomNumber = arc4random_uniform(chars.length);
        NSString *randomChar = [NSString stringWithFormat:@"%C",[chars characterAtIndex:randomNumber]];
        uniqueID = [NSString stringWithFormat:@"%@%@", uniqueID, randomChar];
    }

    //NSLog(@"%@", uniqueID);
    NSString *newStr = [uniqueID substringFromIndex:6];
    NSLog(@"%lu", (unsigned long)newStr.length);
    return newStr;
}

-(BOOL) validateSignUpFields:(NSString *)firstName :(NSString *)lastName :(NSString *)email :(NSString *)password {
    BOOL flag = FALSE;
    if (([firstName  isEqual: @""]) && ([lastName  isEqual: @""]) && ([email  isEqual: @""]) && ([password  isEqual: @""])) {
        flag = FALSE;
    } else {
        flag = TRUE;
    }

    return flag;
}

-(BOOL) validateLoginFields:(NSString *)email :(NSString *)password {
    BOOL flag = FALSE;
    
    // Multiple parameters https://stackoverflow.com/questions/1692005/returning-multiple-values-from-a-method-in-objective-c
    BOOL isValidPassword = NO;
    NSString *error = [self validPassword:password isValid:&isValidPassword];

    isValidPassword = isValidPassword; // recieve isValid parameter back from validPassword function

    if (isValidPassword) {
        //Paswword is of right format
        if (([email isEqual:@""]) && ([password isEqual:@""])) {
            flag = FALSE;
            NSLog(@"Please fill in both fields"); // Also have error variable to send back
        } else {
            flag = TRUE;
        }
    } else {
        // Password was not of right format
        flag = FALSE;
        NSLog(@"%@", error); // Also have error varibale to send back
    }
    return flag;
}

- (NSString *)validPassword:(NSString *)password isValid:(BOOL *)valid {
    // do some validation - source https://stackoverflow.com/questions/2297102/check-nsstring-for-special-characters
    NSCharacterSet *special = [NSCharacterSet characterSetWithCharactersInString:@"!~`@#$%^&*-+();:={}[],.<>?\\/\"\'"];
    NSCharacterSet *capital = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    NSCharacterSet *number = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];

    NSString *error = nil;
    if (password.length > 7) {
        *valid = YES;
        if ([password rangeOfCharacterFromSet:special].length) {
            *valid = YES;
            if ([password rangeOfCharacterFromSet:capital].length) {
                *valid = YES;
                if ([password rangeOfCharacterFromSet:number].length) {
                    *valid = YES;
                } else {
                    *valid = NO;
                    error = @"Password has to contain a NUMBER";
                }
            } else {
                *valid = NO;
                error = @"Password has to contain a CAPITAL LETTER";
            }
        } else {
            *valid = NO;
            error = @"Password has to contain a SPECIAL CHARACTER";
        }
    } else {
        *valid = NO;
        error = @"Password at least 8 characters";
    }
    return error;
}

@end
