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
    _starView1.canSel = YES;
    _starView2.canSel = YES;
    _starView3.canSel = YES;
    _starView1.score = 5;
    _starView2.score = 5;
    _starView3.score = 5;
    _starView1.block = ^(NSInteger score) {
        if (self.block) {
            self.block([NSString stringWithFormat:@"%ld",self.starView1.score], [NSString stringWithFormat:@"%ld",self.starView2.score], [NSString stringWithFormat:@"%ld",self.starView3.score]);
        }
    };
    _starView2.block = ^(NSInteger score) {
        if (self.block) {
            self.block([NSString stringWithFormat:@"%ld",self.starView1.score], [NSString stringWithFormat:@"%ld",self.starView2.score], [NSString stringWithFormat:@"%ld",self.starView3.score]);
        }
    };
    _starView3.block = ^(NSInteger score) {
        if (self.block) {
            self.block([NSString stringWithFormat:@"%ld",self.starView1.score], [NSString stringWithFormat:@"%ld",self.starView2.score], [NSString stringWithFormat:@"%ld",self.starView3.score]);
        }
    };
}
- (void)layoutSubviews
{
//    _starView1.score = 5;
    _starView1.canSel = YES;
//    _starView2.score = 5;
    _starView2.canSel = YES;
//    _starView3.score = 5;
    _starView3.canSel = YES;
}
- (void)setModel:(OrderModel *)model
{
    _model = model;
    [self.storeLogoImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)] placeholderImage:[UIImage imageNamed:@"toko"]];
    self.storeNameLabel.text = model.storeName;
}
- (void)setDetailModel:(OrderDetailModel *)detailModel
{
    _detailModel = detailModel;
    [self.storeLogoImgView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"toko"]];
    self.storeNameLabel.text = detailModel.storeName;
}
- (void)setScore1:(NSString *)score1
{
    _score1 = score1;
    self.starView1.score = score1.integerValue;
}
- (void)setScore2:(NSString *)score2
{
    _score2 = score2;
    self.starView2.score = score2.integerValue;
}
- (void)setScore3:(NSString *)score3
{
    _score3 = score3;
    self.starView3.score = score3.integerValue;
}
- (IBAction)selAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.anonymousblock) {
        self.anonymousblock(sender.selected ? @"Y": @"N");
    }
}


@end
