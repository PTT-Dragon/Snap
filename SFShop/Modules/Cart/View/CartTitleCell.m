//
//  CartTitleCell.m
//  SFShop
//
//  Created by 游挺 on 2021/10/30.
//

#import "CartTitleCell.h"

@interface CartTitleCell ()
@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *offLabel;

@end

@implementation CartTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_selBtn setImage:[UIImage imageNamed:@"block"] forState:UIControlStateDisabled | UIControlStateSelected];
    [_selBtn setImage:[UIImage imageNamed:@"block"] forState:UIControlStateDisabled | UIControlStateNormal];
    [_selBtn setImage:[UIImage imageNamed:@"Vector"] forState:0];
    [_selBtn setImage:[UIImage imageNamed:@"已选中"] forState:1];
}

- (void)setModel:(CartListModel *)model
{
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.logoUrl)]];
    _storeNameLabel.text = model.storeName;
    _offLabel.text = [NSString stringWithFormat:@" RP %.0f OFF ",model.discountPrice];
    if (_isInvalid) {
        _selBtn.enabled = NO;
        return;
    }
    _selBtn.enabled = YES;
    BOOL selAll = YES;
    for (CartItemModel *subModel in model.shoppingCarts) {
        if (![subModel.isSelected isEqualToString:@"Y"]) {
            selAll = NO;
        }
    }
    _selBtn.selected = selAll;
}
- (void)setIsInvalid:(BOOL)isInvalid
{
    _isInvalid = isInvalid;
}
- (IBAction)selAction:(UIButton *)sender {
    if (_isInvalid) {
        return;
    }
    sender.selected = !sender.selected;
    [self.delegate selAll:sender.selected storeId:_model.storeId];
}
- (IBAction)couponAction:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray array];
    [_model.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arr addObject:@{@"productId":obj.productId,@"offerCnt":obj.num}];
        [_model.campaignGroups enumerateObjectsUsingBlock:^(CartCampaignsModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj.shoppingCarts enumerateObjectsUsingBlock:^(CartItemModel *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [arr addObject:@{@"productId":obj.productId,@"offerCnt":obj.num}];
            }];
        }];
    }];
    [self.delegate selCouponWithStoreId:_model.storeId productArr:arr];
}
@end
