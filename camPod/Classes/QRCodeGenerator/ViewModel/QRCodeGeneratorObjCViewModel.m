//
//  QRCodeGeneratorObjCViewModel.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/29.
//

#import "QRCodeGeneratorObjCViewModel.h"

@implementation QRCodeGeneratorObjCViewModel

-(UIImage *) generateQRCodeImage: (NSString *) albumID {
    NSData *data = [albumID dataUsingEncoding:NSASCIIStringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"InputMessage"];
    
    CIImage *ciImage = filter.outputImage;
    
    CGAffineTransform transform = CGAffineTransformMakeScale(10, 10);
    CIImage *transformImage = [ciImage imageByApplyingTransform:transform];
    
    UIImage *image = [[UIImage alloc] initWithCIImage:transformImage];
    
    return image;
}

@end
