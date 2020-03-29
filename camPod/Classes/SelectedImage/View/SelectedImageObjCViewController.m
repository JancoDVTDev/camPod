//
//  SelectedImageObjCViewController.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/29.
//

#import "SelectedImageObjCViewController.h"

@interface SelectedImageObjCViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageImageView;
@end

@implementation SelectedImageObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedImageImageView.image = self.selectedImage;
}

@end
