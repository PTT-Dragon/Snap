//
//  AddReviewStoreItemCell.m
//  SFShop
//
//  Created by 游挺 on 2022/1/23.
//

#import "AddReviewStoreItemCell.h"
#import "StarView.h"

@interface AddReviewStoreItemCell ()
@property (weak, nonatomic) IBOutlet UIButton *anonymousBtn;
@property (weak, nonatomic) IBOutlet UILabel *anonymousLabel;
@property (weak, nonatomic) IBOutlet StarView *starView1;
@property (weak, nonatomic) IBOutlet StarView *starView2;
@property (weak, nonatomic) IBOutlet StarView *starView3;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeLogoImgView;
@end

@implementation AddReviewStoreItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
