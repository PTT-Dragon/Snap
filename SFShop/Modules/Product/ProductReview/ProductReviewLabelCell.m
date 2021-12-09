//
//  ProductReviewLabelCell.m
//  SFShop
//
//  Created by 游挺 on 2021/12/9.
//

#import "ProductReviewLabelCell.h"

@interface ProductReviewLabelCell ()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation ProductReviewLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _label.layer.borderWidth = 1;
}
- (void)setModel:(ProductEvalationLabelsModel *)model
{
    _label.text = model.labelName;
    _label.layer.borderColor = model.sel ? RGBColorFrom16(0xFF1659).CGColor: RGBColorFrom16(0xC4C4C4).CGColor;
    _label.textColor = model.sel ? RGBColorFrom16(0xFF1659): RGBColorFrom16(0xC4C4C4);
}
@end
