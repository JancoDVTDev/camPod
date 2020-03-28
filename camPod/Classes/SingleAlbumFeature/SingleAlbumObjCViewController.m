//
//  SingleAlbumObjCViewController.m
//  camPod
//
//  Created by Janco Erasmus on 2020/03/26.
//

#import "SingleAlbumObjCViewController.h"
#import "PhotoCellCollectionViewCell.h"

@interface SingleAlbumObjCViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *myCollectionView;
//@property (strong, nonatomic) NSArray *albumImages;
//@property (strong, nonatomic) SingleAlbumObjCViewModel *viewModel;
//@property (strong, nonatomic) NSString *albumID;
//@property (strong, nonatomic) NSArray *imagePathReferences;

@end

@implementation SingleAlbumObjCViewController

//- (instancetype)initWithViewModel:(SingleAlbumObjCViewModel *)viewModel {
//    self = [super init];
//    if (!self) return nil;
//
//    self.viewModel = viewModel;
//
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewModel = [[SingleAlbumObjCViewModel alloc] init];
    
    [self.viewModel downloadImagesFromFirebaseStorage:self.albumID :self.imagePathReferences :^(SingleAlbumModelObjc * _Nonnull album) {
        self.albumImages = album.images;
        [self.myCollectionView reloadData];
    }];
    
    
}

-(IBAction)imageTapped:(id)sender {
    //perform segue to single image view
    NSLog(@"Perform segue to Single image view");
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
    return self.albumImages.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentfier = @"PhotoCell";
    PhotoCellCollectionViewCell *cell =
    [self.myCollectionView dequeueReusableCellWithReuseIdentifier:cellIdentfier forIndexPath:indexPath];
    
    UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    
    [cell.imageView setUserInteractionEnabled:YES];
    cell.imageView.tag = indexPath.row;
    [cell.imageView addGestureRecognizer:imageTap];
 
    UIImage *image = self.albumImages[indexPath.item];
    cell.imageView.image = image;
    
    return cell;
    
}

@end
