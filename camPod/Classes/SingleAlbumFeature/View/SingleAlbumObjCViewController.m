//
//  SingleAlbumObjCViewController.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/26.
//

#import "SingleAlbumObjCViewController.h"
#import "PhotoCellCollectionViewCell.h"
#import "QRCodeGeneratorObjCViewController.h"
#import "SelectedImageObjCViewController.h"
//#import "camPod/camPod-Swift.h"

@interface SingleAlbumObjCViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;

@end

@implementation SingleAlbumObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // MARK: Add Navigation Item
    UIBarButtonItem *cameraButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cameraTapped:)];
    self.navigationItem.rightBarButtonItem = cameraButton;
    self.title = self.albumName;
    
    self.viewModel = [[SingleAlbumObjCViewModel alloc] init];
    [self.viewModel downloadImagesFromFirebaseStorage:self.albumID :self.imagePathReferences :^(SingleAlbumModelObjc * _Nonnull album) {
        self.album = album;
        self.albumImages = self.album.images;
        [self.myCollectionView reloadData];
    }];
    
    self.observedImagePaths = [self.viewModel observedImagePaths];
//    BOOL equal = [self.album.imagePathReferences isEqualToArray:self.observedImagePaths];
//    if (equal == NO) {
//        [self.viewModel downloadImagesFromFirebaseStorage:self.albumID :self.imagePathReferences :^(SingleAlbumModelObjc * _Nonnull album) {
//            self.album = album;
//            self.albumImages = self.album.images;
//            [self.myCollectionView reloadData];
//        }];
//    }
    
}
- (IBAction)shareTapped:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Share Album" message:self.album.albumID preferredStyle:UIAlertControllerStyleActionSheet];
    [FIRAnalytics logEventWithName:@"share_album" parameters:nil];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Generate QR Code" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //Create QR code: Display inside Custom view
        [FIRAnalytics logEventWithName:@"generate_gr_code_tapped" parameters:@{@"albumID" : self.album.albumID}];
        [self performSegueWithIdentifier:@"goToQRCode" sender:self];
        //[self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Copy Album ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.album.albumID;
        [FIRAnalytics logEventWithName:@"copy_album_id_tapped" parameters:@{@"albumID" : self.album.albumID}];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [FIRAnalytics logEventWithName:@"cancel_share_tapped" parameters:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (IBAction)deleteTapped:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Delete Album" message:@"Are you sure you want to delete this album ?" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //DeleteAlbum
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"goToQRCode"]) {
        QRCodeGeneratorObjCViewController *qrCodeView = [segue destinationViewController];
        qrCodeView.albumID = self.album.albumID;
    }
    
    if ([[segue identifier] isEqualToString:@"loadPhoto"]) {
        SelectedImageObjCViewController *selectedImageView = [segue destinationViewController];
        selectedImageView.selectedImage = self.selectedImage;
    }
}


-(IBAction)cameraTapped:(id)sender {
    NSLog(@"Camera button tapped");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info {
    NSLog(@"Picture was taken");
    UIImage *takenPhoto = info[UIImagePickerControllerEditedImage];
    if (!takenPhoto) takenPhoto = info[UIImagePickerControllerOriginalImage];
    //self.album.images = [self.viewModel appendToLocalAlbum:self.album.images :takenPhoto];
    [self.viewModel saveImageToFirebase:self.album :takenPhoto :^(BOOL success) {
        [self.myCollectionView reloadData];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat numberOfColumns = 4;
    CGFloat width = self.myCollectionView.frame.size.width;
    CGFloat xInsets = 2;
    CGFloat cellSpacing = 2;
    CGFloat widthSize = (width/numberOfColumns) - (xInsets + cellSpacing);
    CGFloat heigtSize = (width/numberOfColumns) - (xInsets + cellSpacing);
    return CGSizeMake(widthSize, heigtSize);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.album.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentfier = @"PhotoCell";
    PhotoCellCollectionViewCell *cell =
    [self.myCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentfier forIndexPath:indexPath];

    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];

    [cell.imageView setUserInteractionEnabled:YES];
    cell.imageView.tag = indexPath.row;
    [cell.imageView addGestureRecognizer:imageTap];

    UIImage *image = self.album.images[indexPath.item];
    cell.imageView.image = image;

    return cell;
}

-(IBAction)imageTapped:(UITapGestureRecognizer*)sender {
    NSLog(@"Perform segue to Single image view");
    int selectedIndex = sender.view.tag;
    self.selectedImage = self.album.images[selectedIndex];
    [self performSegueWithIdentifier:@"loadPhoto" sender:self];
}

@end
