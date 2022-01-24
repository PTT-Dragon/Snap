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
}
- (void)layoutSubviews
{
    _starView1.score = 5;
    _starView1.canSel = YES;
    _starView2.score = 5;
    _starView2.canSel = YES;
    _starView3.score = 5;
    _starView3.canSel = YES;
}
- (void)setModel:(OrderModel *)model
{
    _model = model;
    [self.storeLogoImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)] placeholderImage:[UIImage imageNamed:@"toko"]];
    self.storeNameLabel.text = model.storeName;
}
- (IBAction)selAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.anonymousblock) {
        self.anonymousblock(sender.selected ? @"Y": @"N");
    }
}


@end
