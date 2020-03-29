//
//  SingleAlbumObjCViewController.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/26.
//

#import <UIKit/UIKit.h>
#import "SingleAlbumObjCViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SingleAlbumObjCViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSArray *albumImages;
@property (strong, nonatomic) SingleAlbumObjCViewModel *viewModel;
@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSArray *imagePathReferences;
@property (strong,nonatomic) NSString *albumName;
@property (strong, nonatomic) SingleAlbumModelObjc *album;
@property (strong, nonatomic) UIImage *selectedImage;

@end

NS_ASSUME_NONNULL_END
