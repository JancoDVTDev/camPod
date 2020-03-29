//
//  QRCodeGeneratorObjCViewController.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/29.
//

#import <UIKit/UIKit.h>
#import "QRCodeGeneratorObjCViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeGeneratorObjCViewController : UIViewController

@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) UIImage *qrCodeImage;
@property (strong, nonatomic) QRCodeGeneratorObjCViewModel *qrCodeViewModel;

@end

NS_ASSUME_NONNULL_END
