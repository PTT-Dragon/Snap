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
}

- (void)setModel:(CartListModel *)model
{
    _model = model;
    [_iconImgView sd_setImageWithURL:[NSURL URLWithString:SFImage(model.logoUrl)]];
    _storeNameLabel.text = model.storeName;
    _offLabel.text = [NSString stringWithFormat:@" RP %.0f OFF ",model.discountPrice];
    BOOL selAll = YES;
    for (CartItemModel *subModel in model.shoppingCarts) {
        if (![subModel.isSelected isEqualToString:@"Y"]) {
            selAll = NO;
        }
    }
    _selBtn.selected = selAll;
}
- (IBAction)selAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    [self.delegate selAll:sender.selected storeId:_model.storeId];
}
@end
