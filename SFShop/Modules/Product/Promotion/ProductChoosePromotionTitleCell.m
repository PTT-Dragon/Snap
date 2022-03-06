//
//  ProductChoosePromotionTitleCell.m
//  SFShop
//
//  Created by 游挺 on 2022/3/6.
//

#import "ProductChoosePromotionTitleCell.h"
#import "UIButton+EnlargeTouchArea.h"


@interface ProductChoosePromotionTitleCell ()
@property (weak, nonatomic) IBOutlet UILabel *offLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end
@implementation ProductChoosePromotionTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [_selBtn setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
}
- (void)setModel:(cmpBuygetnsModel *)model
{
    _model = model;
    _selBtn.selected = model.sel;
    self.offLabel.text = [model.promotType rangeOfString:@"C"].location != NSNotFound ? [NSString stringWithFormat:@" %@ ",kLocalizedString(@"OFF")]: [NSString stringWithFormat:@" %@ ",kLocalizedString(@"DISCOUNT")];
    self.contentLabel.text = model.campaignName;
}
- (IBAction)selAction:(UIButton *)sender {
    _model.sel = !_model.sel;
    if (self.block) {
        self.block(_model.sel);
    }
}
@end
