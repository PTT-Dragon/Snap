//
//  GroupBuyListCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/16.
//

#import "GroupBuyListCell.h"
#import "NSString+Fee.h"



@interface GroupBuyListCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *groupCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *soldLabel;
@property (weak, nonatomic) IBOutlet UIImageView *btnImgView;
@property (weak, nonatomic) IBOutlet UIView *groupInfoBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *groupInfoViewWidth;

@end

@implementation GroupBuyListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _bgView.layer.borderColor = RGBColorFrom16(0xcccccc).CGColor;
    _bgView.layer.borderWidth = 1;
//    _btnImgView.layer.borderColor = RGBColorFrom16(0xff1659).CGColor;
//    _btnImgView.layer.borderWidth = 1;
}
- (void)setModel:(CategoryRankPageInfoListModel *)model
{
    _model = model;
    cmpShareBuysModel *shareModel = model.campaigns.cmpShareBuys.firstObject;
    [_imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.productImg.url)]];
    _nameLabel.text = model.offerName;
    _priceLabel.text = [[NSString stringWithFormat:@"%ld", model.specialPrice ? model.specialPrice:model.salesPrice] currency];
    _marketPriceLabel.text = [NSString stringWithFormat:@"%@", [model.sppMarketPrice currency]];
    _groupCountLabel.text = [NSString stringWithFormat:@"%ld",shareModel.shareByNum];
    _soldLabel.text = [NSString stringWithFormat:@"%ld Sold",(long)model.salesCnt];
    for (UIView *subView in _groupInfoBgView.subviews) {
        [subView removeFromSuperview];
    }
    NSInteger i = 0;
    for (cmpShareBuysModel *shareBuysModel in model.campaigns.cmpShareBuys) {
        for (ProductGroupListModel *listModel in shareBuysModel.groups) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(i*20, 0, 18, 18)];
            [imgView sd_setImageWithURL:[NSURL URLWithString:SFImage(listModel.photo)]];
            i++;
            [_groupInfoBgView addSubview:imgView];
            if (i>= 3) {
                break;
            }
        }
    }
    _groupInfoViewWidth.constant = i*20;
}
@end
