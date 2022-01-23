//
//  AddReviewItemCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import "AddReviewItemCell.h"
#import "StarView.h"

@interface AddReviewItemCell ()
@property (weak, nonatomic) IBOutlet StarView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic,strong) NSMutableArray *imgArr;//存放图片数组
@property (nonatomic,strong) NSMutableArray *imgUrlArr;//存放图片url数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionViewHei;
@end

@implementation AddReviewItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
