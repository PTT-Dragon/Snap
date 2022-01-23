//
//  OrderListStateCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/23.
//

#import "OrderListStateCell.h"

@interface OrderListStateCell ()
@property (weak, nonatomic) IBOutlet UIImageView *storeIconImgview;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statuLabel;

@end

@implementation OrderListStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setContent:(OrderModel *)model
{
    _storeNameLabel.text = model.storeName;
    [_storeIconImgview sd_setImageWithURL:[NSURL URLWithString:SFImage(model.storeLogoUrl)] placeholderImage:[UIImage imageNamed:@"toko"]];
    _statuLabel.text = [model getStateStr];
}
- (void)setOrderDetailContent:(OrderDetailModel *)model
{
    _storeNameLabel.text = model.storeName;
    _storeIconImgview.image = [UIImage imageNamed:@"toko"];
    _statuLabel.text = model.state;
}
- (void)setRelationOrderDetailContent:(OrderDetailModel *)model
{
    _storeNameLabel.text = model.storeName;
    _storeIconImgview.image = [UIImage imageNamed:@"toko"];
    _statuLabel.text = @"";
}
@end
