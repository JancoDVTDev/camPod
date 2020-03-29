//
//  QRCodeGeneratorObjCViewModel.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeGeneratorObjCViewModel : NSObject

-(UIImage *) generateQRCodeImage: (NSString *) albumID;

@end

NS_ASSUME_NONNULL_END
