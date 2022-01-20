//
//  ImageCollectionViewCell.h
//  SFShop
//
//  Created by 游挺 on 2021/12/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ImageCollectionViewCellBlock)(NSInteger index);

@interface ImageCollectionViewCell : UICollectionViewCell
@property (nonatomic,assign) BOOL canDel;
@property (nonatomic,assign) NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (nonatomic,copy) ImageCollectionViewCellBlock block;

@end

NS_ASSUME_NONNULL_END
