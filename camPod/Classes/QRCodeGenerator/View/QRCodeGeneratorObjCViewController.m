//
//  QRCodeGeneratorObjCViewController.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/29.
//

#import "QRCodeGeneratorObjCViewController.h"

@interface QRCodeGeneratorObjCViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *QRCodeImageView;
@end

@implementation QRCodeGeneratorObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.qrCodeViewModel = [[QRCodeGeneratorObjCViewModel alloc] init];
    self.qrCodeImage = [self.qrCodeViewModel generateQRCodeImage:self.albumID];
    self.QRCodeImageView.image = self.qrCodeImage;
}

@end
