//
//  SingleAlbumObjCViewController.h
//  camPod
//
//  Created by Janco Erasmus on 2020/03/26.
//

#import <UIKit/UIKit.h>
#import "SingleAlbumObjCViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface SingleAlbumObjCViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSArray *albumImages;
@property (strong, nonatomic) SingleAlbumObjCViewModel *viewModel;
@property (strong, nonatomic) NSString *albumID;
@property (strong, nonatomic) NSArray *imagePathReferences;
@property (strong,nonatomic) NSString *albumName;

//- (instancetype)initWithViewModel: (SingleAlbumObjCViewModel *) viewModel;

@end

NS_ASSUME_NONNULL_END
