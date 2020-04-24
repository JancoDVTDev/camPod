//
//  SelectedImageObjCViewController.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/29.
//

#import "SelectedImageObjCViewController.h"
#import "camPod-umbrella.h"
#import "camPod-Swift.h"
#import "Pods-camshare-umbrella.h"

@interface SelectedImageObjCViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *selectedImageImageView;
@end

@implementation SelectedImageObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemEdit target:self action:@selector(editTapped)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    self.selectedImageImageView.image = self.selectedImage;
}

-(void) editTapped {
    [self performSegueWithIdentifier:@"photoEditor" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"photoEditor"]) {
        PhotoEditingViewController *photoEditViewController = (PhotoEditingViewController*)[segue destinationViewController];
        photoEditViewController.inEditPhoto = self.selectedImageImageView.image;
        photoEditViewController.originalImage = self.selectedImageImageView.image;
    }
}

@end
